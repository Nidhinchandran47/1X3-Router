//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_regi
// Project Name:    1X3 Router
//  
// Description:     This module registers header data, packet data when the FIFO 
//                  is full, calculates and stores internal parity, and compares 
//                  it with packet parity to generate an error signal.
// 
//////////////////////////////////////////////////////////////////////////////////

module router_regi (
    input           clock,
    input           resetn,
    input           pkt_valid,
    input           fifo_full,
    input           rst_int_reg,
    input           detect_add,
    input           ld_state,
    input           laf_state,
    input           full_state,
    input           lfd_state,
    input[7:0]      data_in,
    output reg      parity_done,
    output reg      low_pkt_valid,
    output reg      err,
    output reg[7:0] dout
);
    reg[7:0]        header_reg, fifo_full_reg, internal_prt_reg, packet_prt_reg;

    always @(posedge clock) begin
        if (!resetn) begin
            header_reg      <=  0;
            fifo_full_reg   <=  0;
        end
        else if (pkt_valid && detect_add && (data_in[1:0] != 2'b11)) begin
            header_reg      <=  data_in;
        end
        else if (ld_state && fifo_full) begin
            fifo_full_reg   <=  data_in;
        end
    end

    always @(posedge clock) begin
        if (!resetn) begin
            dout        <=  8'b0;
        end
        else if (lfd_state) begin
            dout        <=  header_reg;
        end
        else if (ld_state && !fifo_full) begin
            dout        <=  data_in;
        end
        else if (laf_state) begin
            dout        <=  fifo_full_reg;
        end
        else
            dout        <=  dout;
    end

    always @(posedge clock) begin
        if (!resetn) begin
            packet_prt_reg <=0;
            parity_done <=  0;
        end
        else if (detect_add) begin
            packet_prt_reg <=0;
            parity_done <=  0;
        end
        else if (rst_int_reg) begin
            packet_prt_reg <=0;
            parity_done <=  0;
        end
        else if ((ld_state && !pkt_valid && !fifo_full) || (laf_state && !parity_done && low_pkt_valid)) begin
            packet_prt_reg  <=  data_in;
            parity_done     <=  1;
        end
    end

    always @(posedge clock) begin
        if (!resetn) begin
            low_pkt_valid   <=  0;
        end
        else if (ld_state && !pkt_valid) begin
            low_pkt_valid   <=  1;
        end
    end

    always @(posedge clock) begin
        if (!resetn) begin
            internal_prt_reg    <=  0;
        end
        else if (detect_add) begin
            internal_prt_reg    <=  0;   
        end
        else if (rst_int_reg) begin
            internal_prt_reg    <=  0;
        end
        else if (lfd_state) begin
            internal_prt_reg    <=  internal_prt_reg    ^   header_reg;
        end
        else if (ld_state && !full_state && pkt_valid) begin
            internal_prt_reg    <=  internal_prt_reg    ^   data_in;
        end
        else
            internal_prt_reg    <=  internal_prt_reg;
    end

    always @(posedge clock) begin
        if (!resetn) begin
            err         <=  0;
        end
        else begin
            if (parity_done) begin
                if (internal_prt_reg != packet_prt_reg) begin
                    err         <=  1;
                end
                else 
                    err         <=  0; 
            end
            else
                 err            <=  0;
        end
    end
    
endmodule
