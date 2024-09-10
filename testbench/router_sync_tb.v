//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_sync_tb
// Project Name:    1X3 Router
//  
// Description:     Testbench to verify the module - router_sync
// 
//////////////////////////////////////////////////////////////////////////////////

module router_sync_tb ();
    reg        detect_add;
    reg        write_enb_reg;
    reg        clock;
    reg        resetn;
    reg        read_enb_0;
    reg        read_enb_1;
    reg        read_enb_2;
    reg        empty_0;
    reg        empty_1;
    reg        empty_2;
    reg        full_0;
    reg        full_1;
    reg        full_2;
    reg [1:0]  data_in;
    wire       vld_out_0;
    wire       vld_out_1;
    wire       vld_out_2;
    wire       soft_reset_0;
    wire       soft_reset_1;
    wire       soft_reset_2;
    wire       fifo_full;
    wire[2:0]  write_enb;

    router_sync DUT (
        .detect_add(detect_add),
        .write_enb_reg(write_enb_reg),
        .clock(clock),
        .resetn(resetn),
        .read_enb_0(read_enb_0),
        .read_enb_1(read_enb_1),
        .read_enb_2(read_enb_2),
        .empty_0(empty_0),
        .empty_1(empty_1),
        .empty_2(empty_2),
        .full_0(full_0),
        .full_1(full_1),
        .full_2(full_2),
        .data_in(data_in),
        .vld_out_0(vld_out_0),
        .vld_out_1(vld_out_1),
        .vld_out_2(vld_out_2),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2),
        .fifo_full(fifo_full),
        .write_enb(write_enb)
    );

    task reset();begin
        @ (negedge clock);
        detect_add      <=0;
        write_enb_reg   <=0;
        resetn          <=0;
        read_enb_0      <=0;
        read_enb_1      <=0;
        read_enb_2      <=0;
        empty_0         <=0;
        empty_1         <=0;
        empty_2         <=0;
        full_0          <=0;
        full_1          <=0;
        full_2          <=0;
        data_in         <=0;
        @ (negedge clock);
        resetn          <=1;
        read_enb_0      <=1;
        read_enb_1      <=1;
        read_enb_2      <=1;
    end
    endtask

    task test_write_enable(input[1:0] i); begin
        @(negedge clock);
        data_in <= i;
        @(negedge clock);
        write_enb_reg <=1;
        detect_add <= 1;
    end
    endtask

    task test_fifo_full();begin
        @(negedge clock);
        full_0          <=1;
        full_1          <=0;
        full_2          <=0;
        @(negedge clock);
        full_0          <=0;
        full_1          <=1;
        full_2          <=0;
        @(negedge clock);
        full_0          <=0;
        full_1          <=0;
        full_2          <=1;
        @(negedge clock);
        full_0          <=0;
        full_1          <=0;
        full_2          <=0;
    end
    endtask

    task test_timeout (input[1:0]k); begin
        if (k == 0) begin
            @(negedge clock);
            empty_0 <= 0;
            read_enb_0 <= 0;
            repeat(31)
                @(negedge clock);
            read_enb_0 <= 1;
            empty_0 <= 1;
            @(negedge clock);
            read_enb_0 <= 0;
            empty_0 <= 0;
            @(negedge clock);
            read_enb_0 <= 1;
        end
        else if (k == 1) begin
            @(negedge clock);
            empty_1 <= 0;
            read_enb_1 <= 0;
            repeat(31)
                @(negedge clock);
            read_enb_1 <= 1;
            empty_1 <= 1;
            @(negedge clock);
            read_enb_1 <= 0;
            empty_1 <= 0;
            @(negedge clock);
            read_enb_1 <= 1;
        end
        else if (k == 2) begin
            @(negedge clock);
            empty_2 <= 0;
            read_enb_2 <= 0;
            repeat(31)
                @(negedge clock);
            read_enb_2 <= 1;
            empty_2 <= 1;
            @(negedge clock);
            read_enb_2 <= 0;
            empty_2 <= 0;
            @(negedge clock);
            read_enb_2 <= 1;
        end
    end
    endtask

    always  begin
        #5
        clock  = ~clock;
     end

    initial begin
        clock = 0;
        reset();
        test_write_enable(0);
        test_fifo_full;
        test_write_enable(1);
        test_fifo_full;
        test_write_enable(2);
        test_fifo_full;
        test_timeout(0);
        test_timeout(1);
        test_timeout(2);
        $finish;
    end

endmodule