interface router_if (
    input logic clock
);
  logic resetn;
  logic read_enb;
  logic pkt_valid;
  logic [7:0] data_in;
  logic valid_out;
  logic error;
  logic busy;
  logic [7:0] data_out;

  clocking src_drv_cb @(posedge clock);
    default input #1 output #1;
    input error;
    input busy;
    output data_in;
    output pkt_valid;
    output resetn;
  endclocking

  clocking src_mon_cb @(posedge clock);
    default input #1 output #1;
    input error;
    input busy;
    input data_in;
    input pkt_valid;
    input resetn;
  endclocking

  clocking dest_drv_cb @(posedge clock);
    default input #1 output #1;
    output read_enb;
    input data_out;
    input valid_out;
  endclocking

  clocking dest_mon_cb @(posedge clock);
    default input #1 output #1;
    input read_enb;
    input valid_out;
    input data_out;
  endclocking

  modport SRC_DRV_MP(clocking src_drv_cb);
  modport SRC_MON_MP(clocking src_mon_cb);
  modport DEST_DRV_MP(clocking dest_drv_cb);
  modport DEST_MON_MP(clocking dest_mon_cb);

endinterface

