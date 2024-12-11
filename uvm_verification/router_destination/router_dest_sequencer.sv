class router_dest_sequencer extends uvm_sequencer #(dest_xtn);

  `uvm_component_utils(router_dest_sequencer)
  extern function new(string name = "router_dest_sequencer", uvm_component parent);

endclass

function router_dest_sequencer::new(string name = "router_dest_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction
