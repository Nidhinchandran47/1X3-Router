module top;
  import router_pkg::*;
  import uvm_pkg::*;

  bit clock;
  always #5 clock = ~clock;

  router_if in_s (clock);
  router_if in_d0 (clock);
  router_if in_d1 (clock);
  router_if in_d2 (clock);

  router_top DUV (
      .clock(clock),
      .resetn(in_s.resetn),
      .read_enb_0(in_d0.read_enb),
      .read_enb_1(in_d1.read_enb),
      .read_enb_2(in_d2.read_enb),
      .pkt_valid(in_s.pkt_valid),
      .data_in(in_s.data_in),
      .valid_out_0(in_d0.valid_out),
      .valid_out_1(in_d1.valid_out),
      .valid_out_2(in_d2.valid_out),
      .error(in_s.error),
      .busy(in_s.busy),
      .data_out_0(in_d0.data_out),
      .data_out_1(in_d1.data_out),
      .data_out_2(in_d2.data_out)
  );

  initial begin

`ifdef VCS
    $fsdbDumpvars(0, top);
`endif

    uvm_config_db#(virtual router_if)::set(null, "*", "vifs_0", in_s);
    uvm_config_db#(virtual router_if)::set(null, "*", "vifd_0", in_d0);
    uvm_config_db#(virtual router_if)::set(null, "*", "vifd_1", in_d1);
    uvm_config_db#(virtual router_if)::set(null, "*", "vifd_2", in_d2);

    run_test();
  end

// Assertion

  property pkt_valid_busy;
    @(posedge clock) $rose(
        in_s.pkt_valid
    ) |=> in_s.busy;
  endproperty

  property busy_datain;
    @(posedge clock) in_s.busy |=> $stable(
        in_s.data_in
    );
  endproperty

  property read0;
    @(posedge clock) $rose(
        in_d0.valid_out
    ) |=> ##[0:29] in_d0.read_enb;
  endproperty

  property read1;
    @(posedge clock) $rose(
        in_d1.valid_out
    ) |=> ##[0:29] in_d1.read_enb;
  endproperty

  property read2;
    @(posedge clock) $rose(
        in_d2.valid_out
    ) |=> ##[0:29] in_d2.read_enb;
  endproperty

  property lowread0;
    @(posedge clock) in_d0.valid_out ##1 !in_d0.valid_out |=> $fell(
        in_d0.read_enb
    );
  endproperty

  property lowread1;
    @(posedge clock) in_d1.valid_out ##1 !in_d1.valid_out |=> $fell(
        in_d1.read_enb
    );
  endproperty

  property lowread2;
    @(posedge clock) in_d2.valid_out ##1 !in_d2.valid_out |=> $fell(
        in_d2.read_enb
    );
  endproperty

  A1 :
  assert property (pkt_valid_busy) $display("Assertion A1 success");
  else $display("Assertion A1 failed!");

  A2 :
  assert property (busy_datain) $display("Assertion A2 success");
  else $display("Assertion A2 failed!");

  A3 :
  assert property (read0) $display("Assertion A3 success");
  else $display("Assertion A3 failed!");

  A5 :
  assert property (read1) $display("Assertion A5 success");
  else $display("Assertion A5 failed!");

  A4 :
  assert property (read2) $display("Assertion A4 success");
  else $display("Assertion A4 failed!");

  A6 :
  assert property (lowread0) $display("Assertion A6 success");
  else $display("Assertion A6 failed!");

  A7 :
  assert property (lowread1) $display("Assertion A7 success");
  else $display("Assertion A7 failed!");

  A8 :
  assert property (lowread2) $display("Assertion A8 success");
  else $display("Assertion A8 failed!");



endmodule

