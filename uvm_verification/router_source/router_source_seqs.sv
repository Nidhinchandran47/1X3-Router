class base_seq extends uvm_sequence #(source_xtn);
  `uvm_object_utils(base_seq)

  function new(string name = "base_seq");
    super.new(name);
  endfunction
endclass

class small_seq extends base_seq;
  `uvm_object_utils(small_seq)

  bit [1:0] addr;

  function new(string name = "small_seq");
    super.new(name);
  endfunction

  task body();
    if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		  `uvm_fatal(get_type_name(), "cannot get the cfg")
	  req = source_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;});
    `uvm_info("SOURCE_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
    finish_item(req);
  endtask
endclass

class med_seq extends base_seq;
  `uvm_object_utils(med_seq)
  bit [1:0] addr;

  function new(string name = "med_seq");
    super.new(name);
  endfunction

  task body();
    if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		  `uvm_fatal(get_type_name(), "cannot get the cfg")
    req = source_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] == addr;});
    `uvm_info("SOURCE_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
    finish_item(req);
  endtask
endclass

class big_seq extends base_seq;
  `uvm_object_utils(big_seq)
  bit [1:0] addr;
  
  function new(string name = "big_seq");
    super.new(name);
  endfunction

  task body();
    if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "bit[1:0]", addr))
		  `uvm_fatal(get_type_name(), "cannot get the cfg")
    req = source_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with {header[7:2] inside {[30:60]} && header[1:0] == addr;});
    `uvm_info("SOURCE_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
    finish_item(req);
  endtask
endclass
