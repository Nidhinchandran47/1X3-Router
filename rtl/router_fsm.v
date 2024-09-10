//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_fsm
// Project Name:    1X3 Router
//  
// Description:     Finite State Machine (FSM) for a router to manage packet
//                  processing, including states for decoding address, loading data,
//                  handling FIFO full conditions, and checking for parity errors.
// 
//////////////////////////////////////////////////////////////////////////////////

module router_fsm (
    input           clock,              
    input           resetn,
    input           pkt_valid,
    input           parity_done,
    input           soft_reset_0,
    input           soft_reset_1,
    input           soft_reset_2,
    input           fifo_full,
    input           low_pkt_valid,
    input           fifo_empty_0,
    input           fifo_empty_1,
    input           fifo_empty_2,
    input [1:0]     data_in,
    output          busy,
    output          detect_add,
    output          ld_state,
    output          laf_state,
    output          full_state,
    output          write_enb_reg,
    output          rst_int_reg,
    output          lfd_state);

    reg [2:0]       present_state, next_state;
    reg [1:0]       fsm_addr;

    parameter       DECODE_ADDRESS      =   3'b000;
    parameter       LOAD_FIRST_DATA     =   3'b001;
    parameter       LOAD_DATA           =   3'b010;
    parameter       FIFO_FULL_STATE     =   3'b011;
    parameter       LOAD_AFTER_FULL     =   3'b100;
    parameter       LOAD_PARITY         =   3'b101;
    parameter       CHECK_PARITY_ERROR  =   3'b110;
    parameter       WAIT_TILL_EMPTY     =   3'b111;
    
//----- Capture Destination Address -----
    always @(posedge clock) begin
        if (!resetn) begin
            fsm_addr <= 2'b00;
        end
        else if (detect_add) begin
            fsm_addr <= data_in;
        end
    end
    
//----- Present State Logic ----------
    always @(posedge clock) begin
        if (!resetn) begin
            present_state <= DECODE_ADDRESS;
        end
        else if ((soft_reset_0 && fsm_addr == 2'b00) ||
                 (soft_reset_1 && fsm_addr == 2'b01) ||
                 (soft_reset_2 && fsm_addr == 2'b10)  ) begin
            present_state <= DECODE_ADDRESS;
        end
        else
            present_state <= next_state;
    end

//------- Next State Logic ------------
    always @(*) begin
        case (present_state)
            DECODE_ADDRESS    : begin
                                    if ((pkt_valid && (data_in[1:0] == 0) && fifo_empty_0) ||
                                        (pkt_valid && (data_in[1:0] == 1) && fifo_empty_1) ||
                                        (pkt_valid && (data_in[1:0] == 2) && fifo_empty_2) ) begin
                                        next_state     <=   LOAD_FIRST_DATA;
                                    end
                                    else if ((pkt_valid && (data_in[1:0] == 0) && !fifo_empty_0) ||
                                        (pkt_valid && (data_in[1:0] == 1) && !fifo_empty_1) ||
                                        (pkt_valid && (data_in[1:0] == 2) && !fifo_empty_2) ) begin
                                        next_state     <=   WAIT_TILL_EMPTY;
                                    end
                                    else
                                        next_state     <=   DECODE_ADDRESS;
                                end 
                                
            LOAD_FIRST_DATA   : begin
                                    next_state         <=  LOAD_DATA;
                                end

            LOAD_DATA         : begin
                                    if (fifo_full) begin
                                        next_state     <=   FIFO_FULL_STATE;
                                    end
                                    else if (!fifo_full && !pkt_valid) begin
                                        next_state     <=   LOAD_PARITY;
                                    end
                                    else
                                        next_state     <=   LOAD_DATA;
                                end

            FIFO_FULL_STATE   : begin
                                    if (!fifo_full) begin
                                        next_state     <=   LOAD_AFTER_FULL;
                                    end
                                    else
                                        next_state     <=   FIFO_FULL_STATE;
                                end

            LOAD_AFTER_FULL   : begin
                                    if (parity_done) begin
                                        next_state     <=   DECODE_ADDRESS;
                                    end
                                    else if (!parity_done && low_pkt_valid) begin
                                        next_state     <=   LOAD_PARITY;
                                    end
                                    else if (!parity_done && !low_pkt_valid) begin
                                        next_state     <=   LOAD_DATA;
                                    end
                                    else
                                        next_state     <=   LOAD_AFTER_FULL;
                                end

            LOAD_PARITY       : begin
                                        next_state     <=   CHECK_PARITY_ERROR;
                                end 

            CHECK_PARITY_ERROR: begin
                                    if (!fifo_full) begin
                                        next_state     <=   DECODE_ADDRESS;
                                    end
                                    else
                                        next_state     <=   CHECK_PARITY_ERROR;
                                end 

            WAIT_TILL_EMPTY   : begin
                                    if ((fifo_empty_0 && (fsm_addr == 0)) ||
                                        (fifo_empty_1 && (fsm_addr == 1)) ||
                                        (fifo_empty_2 && (fsm_addr == 2)) ) begin
                                        next_state     <=   LOAD_FIRST_DATA;
                                    end
                                    else
                                        next_state     <=   WAIT_TILL_EMPTY;
                                end 
            
            default           :         next_state     <=   DECODE_ADDRESS;

        endcase
    end

//------- Output Logic ---------------

    assign  busy        =   ((present_state ==  LOAD_FIRST_DATA) ||
                             (present_state ==  LOAD_PARITY) ||
                             (present_state ==  FIFO_FULL_STATE) ||
                             (present_state ==  LOAD_AFTER_FULL) ||
                             (present_state ==  WAIT_TILL_EMPTY) ||
                             (present_state ==  CHECK_PARITY_ERROR))    ? 1 : 0;
    assign  detect_add  =   ((present_state ==  DECODE_ADDRESS))        ? 1 : 0;
    assign  lfd_state   =   ((present_state ==  LOAD_FIRST_DATA))       ? 1 : 0;
    assign  ld_state    =   ((present_state ==  LOAD_DATA))             ? 1 : 0;
    assign  write_enb_reg=  ((present_state ==  LOAD_DATA) ||
                             (present_state ==  LOAD_AFTER_FULL) ||
                             (present_state ==  LOAD_PARITY))           ? 1 : 0;
    assign  full_state  =   ((present_state ==  FIFO_FULL_STATE))       ? 1 : 0;
    assign  laf_state   =   ((present_state ==  LOAD_AFTER_FULL))       ? 1 : 0;
    assign  rst_int_reg =   ((present_state ==  CHECK_PARITY_ERROR))    ? 1 : 0;

endmodule