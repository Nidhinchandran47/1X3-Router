//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_fifo
// Project Name:    1X3 Router
//  
// Description:     FIFO buffer for a router with read and write operations, 
//                  including mechanisms for handling reset and soft reset conditions.
// 
//////////////////////////////////////////////////////////////////////////////////

module router_fifo (
    input           clock,              //  Clock Signal
    input           resetn,             //  Asynchronous reset, active low
    input           write_enb,          //  Write enable
    input           soft_reset,         //  Soft reset signal
    input           read_enb,           //  Read enable
    input           lfd_state,          //  First data state indicator
    input [7:0]     data_in,            //  Data input
    output          empty,              //  FIFO empty flag
    output          full,               //  FIFO full flag
    output reg [7:0]data_out            //  Data output
);
    reg [8:0] mem [0:15];               // Memory to store FIFO data with an extra bit for lfd_state

    reg [4:0] wr_ptr, re_ptr;           // Write and read pointers
    reg [7:0] fifo_counter;             // Counter for FIFO data
    reg lfd_state_s;                    // Latch for lfd_state
    wire zero_do;

    assign zero_do = (data_out != 0);
    integer i;

    // Latching the first data state
    always @(posedge clock) begin
        if (!resetn) 
            lfd_state_s <= 1'b0;
        else
            lfd_state_s <= lfd_state;
    end

    // Updating write and read pointers
    always @(posedge clock) begin
        if (!resetn) 
            {wr_ptr, re_ptr} <= 0;
        else if (soft_reset) 
            {wr_ptr, re_ptr} <= 0;
        else begin
            if (write_enb && !full)
                wr_ptr <= wr_ptr + 1; 
            else
                wr_ptr <= wr_ptr;
            
            if (read_enb && !empty) 
                re_ptr <= re_ptr + 1;
            else
                re_ptr <= re_ptr;
        end
    end

    // Managing FIFO counter 
    always @(posedge clock) begin
        if (!resetn) begin
            fifo_counter <= 0;
        end
        else if (soft_reset) begin
            fifo_counter <= 0;
        end
        else if (read_enb && ! empty) begin
            if (mem[re_ptr[3:0]][8] == 1) begin                 //  If the packet is header
                fifo_counter <= mem [re_ptr[3:0]][7:2] + 1;     //  Counter is Payload(header[7:2]) + 1(parity)
            end
            else if (fifo_counter != 0) begin                   //  else
                fifo_counter <= fifo_counter - 1;               //  decrement
            end
        end
	else
		fifo_counter <= fifo_counter;
    end

    // Reading data from FIFO
    always @(posedge clock) begin
        if (!resetn) begin
            data_out <= 0;
        end
        else if (soft_reset) begin
            data_out <= 8'hz;
        end
        else if (fifo_counter == 0 && zero_do ) begin
            data_out <= 8'hz;
        end
        else if (read_enb && !empty) begin
            data_out <= mem[re_ptr[3:0]];
        end
	else
		data_out <= data_out;
    end

    // Writing data to FIFO
    always @(posedge clock) begin
        if (!resetn) begin
            for (i = 0; i < 16; i = i + 1) begin
                mem[i] <= 0;
            end
        end
        else if (soft_reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                mem[i] <= 0;
            end
        end
        else if (write_enb && !full) begin
            mem [wr_ptr[3:0]] <= {lfd_state_s, data_in};
        end
    end

    // Generating full and empty flags
    assign full = (wr_ptr == {~re_ptr[4], re_ptr[3:0]});
    assign empty = (wr_ptr == re_ptr);
    
endmodule
