class router_source_sequencer extends uvm_sequencer #(source_xtn);

  `uvm_component_utils(router_source_sequencer)
  extern function new(string name = "router_source_sequencer", uvm_component parent);

endclass

function router_source_sequencer::new(string name = "router_source_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction

