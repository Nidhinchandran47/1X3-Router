//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_sync
// Project Name:    1X3 Router
//  
// Description:     Synchronizes signals between the FSM and FIFO modules.
// 
//////////////////////////////////////////////////////////////////////////////////

module router_sync (
    input           detect_add,
    input           write_enb_reg,
    input           clock,
    input           resetn,
    input           read_enb_0,
    input           read_enb_1,
    input           read_enb_2,
    input           empty_0,
    input           empty_1,
    input           empty_2,
    input           full_0,
    input           full_1,
    input           full_2,
    input [1:0]     data_in,
    output          vld_out_0,
    output          vld_out_1,
    output          vld_out_2,
    output reg      soft_reset_0,
    output reg      soft_reset_1,
    output reg      soft_reset_2,
    output reg      fifo_full,
    output reg[2:0] write_enb
);
    reg [1:0]fifo_addr;
    reg [4:0]count0,count1,count2;

    wire c1,c2,c0;

    assign c0 = (count0==5'd30);
    assign c1 = (count1==5'd30);
    assign c2 = (count2==5'd30);

//----- Capture Destination Address
    always @(posedge clock) begin
        if (!resetn) begin
            fifo_addr <= 0;
        end
        else if (detect_add) begin
            fifo_addr <= data_in;
        end
    end

//----- Write enable logic
    always @(*) begin
        if (write_enb_reg) begin
            case (fifo_addr)
                2'b00 : write_enb = 3'b001;
                2'b01 : write_enb = 3'b010;
                2'b10 : write_enb = 3'b100;
                default: write_enb = 3'b0;
            endcase
        end
        else write_enb = 3'b0;
    end

//------ Fifo full generation logic
    always @(*) begin
        case (fifo_addr)
            2'b00 : fifo_full = full_0;
            2'b01 : fifo_full = full_1;
            2'b10 : fifo_full = full_2;
            default: fifo_full = 0;
        endcase
    end

//----- Timeout logic
    always @(posedge clock) begin // destination 0
        if(!resetn) begin
            soft_reset_0<=1'b0;
			count0<=5'b0;
		end
		else if(vld_out_0)
			begin
				if(!read_enb_0)
					begin
						if(c0)	
							begin
								soft_reset_0<=1'b1;
								count0<=1'b0;
							end
						else
							begin
								count0<=count0+1'b1;
								soft_reset_0<=1'b0;
							end
					end
				else count0<=5'd0;
			end
		else count0<=5'd0;
    end

    always @(posedge clock) begin  //destination 1
        if(!resetn) begin
            soft_reset_1<=1'b0;
			count1<=5'b0;
		end
		else if(vld_out_1)
			begin
				if(!read_enb_1)
					begin
						if(c1)	
							begin
								soft_reset_1<=1'b1;
								count1<=1'b0;
							end
						else
							begin
								count1<=count1+1'b1;
								soft_reset_1<=1'b0;
							end
					end
				else count1<=5'd0;
			end
		else count1<=5'd0;
    end

    always @(posedge clock) begin  // destination 2
        if(!resetn) begin
            soft_reset_2<=1'b0;
			count2<=5'b0;
		end
		else if(vld_out_2)
			begin
				if(!read_enb_2)
					begin
						if(c2)	
							begin
								soft_reset_2<=1'b1;
								count2<=1'b0;
							end
						else
							begin
								count2<=count2+1'b1;
								soft_reset_2<=1'b0;
							end
					end
				else count2<=5'd0;
			end
		else count2<=5'd0;
    end

//----- Valid output generation logic
    assign vld_out_0 = ~empty_0;
    assign vld_out_1 = ~empty_1;
    assign vld_out_2 = ~empty_2;

endmodule
