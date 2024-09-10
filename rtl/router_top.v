//////////////////////////////////////////////////////////////////////////////////
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_top
// Project Name:    1X3 Router
//  
// Description:     Top module which interconnects all submodule of router
// 
//////////////////////////////////////////////////////////////////////////////////

module router_top (
    input           clock,
    input           resetn,
    input           read_enb_0,
    input           read_enb_1,
    input           read_enb_2,
    input           pkt_valid,
    input[7:0]      data_in,
    output          valid_out_0,
    output          valid_out_1,
    output          valid_out_2,
    output          error,
    output          busy,
    output[7:0]     data_out_0,
    output[7:0]     data_out_1,
    output[7:0]     data_out_2
);
    
    wire            fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_0, full_1, full_2;
    wire            full_state, lfd_state, parity_done, low_pkt_valid, write_enb_reg;
    wire [7:0]      dout;
    wire            soft_reset_0, soft_reset_1, soft_reset_2, fifo_empty_0, fifo_empty_1, fifo_empty_2;
    wire [2:0]      write_enb;

    // Instantiate the Register Module
    router_regi register (
        .clock          (clock),
        .resetn         (resetn),
        .pkt_valid      (pkt_valid),
        .fifo_full      (fifo_full),
        .rst_int_reg    (rst_int_reg),
        .detect_add     (detect_add),
        .ld_state       (ld_state),
        .laf_state      (laf_state),
        .full_state     (full_state),
        .lfd_state      (lfd_state),
        .data_in        (data_in),
        .parity_done    (parity_done),
        .low_pkt_valid  (low_pkt_valid),
        .err            (error),
        .dout           (dout)
    );

    // Instantiate the FSM Module
    router_fsm fsm (
        .clock          (clock),
        .resetn         (resetn),
        .pkt_valid      (pkt_valid),
        .parity_done    (parity_done),
        .soft_reset_0   (soft_reset_0),
        .soft_reset_1   (soft_reset_1),
        .soft_reset_2   (soft_reset_2),
        .fifo_full      (fifo_full),
        .low_pkt_valid  (low_pkt_valid),
        .fifo_empty_0   (fifo_empty_0),
        .fifo_empty_1   (fifo_empty_1),
        .fifo_empty_2   (fifo_empty_2),
        .data_in        (data_in[1:0]),
        .busy           (busy),
        .detect_add     (detect_add),
        .ld_state       (ld_state),
        .laf_state      (laf_state),
        .full_state     (full_state),
        .write_enb_reg  (write_enb_reg),
        .rst_int_reg    (rst_int_reg),
        .lfd_state      (lfd_state)
    );

    // Instantiate the Synchronizer Module
    router_sync synchronizer (
        .detect_add     (detect_add),
        .write_enb_reg  (write_enb_reg),
        .clock          (clock),
        .resetn         (resetn),
        .read_enb_0     (read_enb_0),
        .read_enb_1     (read_enb_1),
        .read_enb_2     (read_enb_2),
        .empty_0        (fifo_empty_0),
        .empty_1        (fifo_empty_1),
        .empty_2        (fifo_empty_2),
        .full_0         (full_0),
        .full_1         (full_1),
        .full_2         (full_2),
        .data_in        (data_in[1:0]),
        .vld_out_0      (valid_out_0),
        .vld_out_1      (valid_out_1),
        .vld_out_2      (valid_out_2),
        .soft_reset_0   (soft_reset_0),
        .soft_reset_1   (soft_reset_1),
        .soft_reset_2   (soft_reset_2),
        .fifo_full      (fifo_full),
        .write_enb      (write_enb)
    );

    // Instantiate the FIFO to the destination 0
    router_fifo fifo_0 (
        .clock          (clock),
        .resetn         (resetn),
        .write_enb      (write_enb[0]),
        .soft_reset     (soft_reset_0),
        .read_enb       (read_enb_0),
        .lfd_state      (lfd_state),
        .data_in        (dout),
        .full           (full_0),
        .empty          (fifo_empty_0),
        .data_out       (data_out_0)
    );

    // Instantiate the FIFO to the destination 1
    router_fifo fifo_1 (
        .clock          (clock),
        .resetn         (resetn),
        .write_enb      (write_enb[1]),
        .soft_reset     (soft_reset_1),
        .read_enb       (read_enb_1),
        .lfd_state      (lfd_state),
        .data_in        (dout),
        .full           (full_1),
        .empty          (fifo_empty_1),
        .data_out       (data_out_1)
    );

    // Instantiate the FIFO to the destination 2
    router_fifo fifo_2 (
        .clock          (clock),
        .resetn         (resetn),
        .write_enb      (write_enb[2]),
        .soft_reset     (soft_reset_2),
        .read_enb       (read_enb_2),
        .lfd_state      (lfd_state),
        .data_in        (dout),
        .full           (full_2),
        .empty          (fifo_empty_2),
        .data_out       (data_out_2)
    );

endmodule