//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_fsm_tb
// Project Name:    1X3 Router
//  
// Description:     Testbench to verify the module - router_fsm
// 
//////////////////////////////////////////////////////////////////////////////////

module router_fsm_tb ();
    reg           clock;
    reg           resetn;
    reg           pkt_valid;
    reg           parity_done;
    reg           soft_reset_0;
    reg           soft_reset_1;
    reg           soft_reset_2;
    reg           fifo_full;
    reg           low_pkt_valid;
    reg           fifo_empty_0;
    reg           fifo_empty_1;
    reg           fifo_empty_2;
    reg [1:0]     data_in;
    wire          busy;
    wire          detect_add;
    wire          ld_state;
    wire          laf_state;
    wire          full_state;
    wire          write_enb_reg;
    wire          rst_int_reg;
    wire          lfd_state;

    router_fsm DUT (
        .clock(clock),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .parity_done(parity_done),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2),
        .fifo_full(fifo_full),
        .low_pkt_valid(low_pkt_valid),
        .fifo_empty_0(fifo_empty_0),
        .fifo_empty_1(fifo_empty_1),
        .fifo_empty_2(fifo_empty_2),
        .data_in(data_in),
        .busy(busy),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .write_enb_reg(write_enb_reg),
        .rst_int_reg(rst_int_reg),
        .lfd_state(lfd_state)
    );

    always  begin
        #5
        clock  = 0;
        #5
        clock  = 1;
    end

    task reset(); begin
        @ (negedge clock);
        resetn = 0;
        soft_reset_0 = 0;
        soft_reset_1 = 0;
        soft_reset_2 = 0;
        fifo_empty_0 = 0;
        fifo_empty_1 = 0;
        fifo_empty_2 = 0;
        @ (negedge clock);
        resetn = 1;
    end
    endtask

    task task1(); begin
        @ (negedge clock);
        pkt_valid       =   1'b1;
        data_in         =   2'b01;
        fifo_empty_1    =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
        pkt_valid       =   1'b0;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
    end
    endtask

    task task2(); begin
        @ (negedge clock);
        pkt_valid       =   1'b1;
        data_in         =   2'b10;
        fifo_empty_2    =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b1;
        @ (negedge clock);
        fifo_full       =   1'b0;
        @ (negedge clock);
        parity_done     =   1'b0;
        low_pkt_valid   =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
    end
    endtask

    task task3(); begin
        @ (negedge clock);
        pkt_valid       =   1'b1;
        data_in         =   2'b10;
        fifo_empty_2    =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b1;
        @ (negedge clock);
        fifo_full       =   1'b0;
        @ (negedge clock);
        parity_done     =   1'b0;
        low_pkt_valid   =   1'b0;
        @ (negedge clock);
        fifo_full       =   1'b0;
        pkt_valid       =   1'b0;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
    end
    endtask

    task task4(); begin
        @ (negedge clock);
        pkt_valid       =   1'b1;
        data_in         =   2'b01;
        fifo_empty_1    =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
        pkt_valid       =   1'b0;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b1;
        @ (negedge clock);
        fifo_full       =   1'b0;
        @ (negedge clock);
        parity_done     =   1'b1;
    end
    endtask

    task task5(); begin
        @ (negedge clock);
        pkt_valid       =   1'b1;
        data_in         =   2'b01;
        fifo_empty_1    =   1'b0;
        @ (negedge clock);
        fifo_empty_1    =   1'b1;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
        pkt_valid       =   1'b0;
        @ (negedge clock);
        @ (negedge clock);
        fifo_full       =   1'b0;
    end
    endtask

    initial begin
        reset();
        task1;
        task2;
        task3;
        task4;
        task5;
        $finish;
    end

endmodule