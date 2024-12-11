class base_dseqs extends uvm_sequence #(dest_xtn);

  `uvm_object_utils(base_dseqs)

  function new(string name = "base_dseqs");
    super.new(name);
  endfunction

endclass

class small_dseq extends base_dseqs;

  `uvm_object_utils(small_dseq)

  function new(string name = "small_dseq");
    super.new(name);
  endfunction

  task body();
    req = dest_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with {delay inside {[5:10]};});
    `uvm_info("DEST_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
    finish_item(req);
  endtask

endclass

class delay_dseq extends base_dseqs;

  `uvm_object_utils(delay_dseq)

  function new(string name = "delay_dseq");
    super.new(name);
  endfunction

  task body();
    req = dest_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with {delay inside {[30:45]};});
    `uvm_info("DEST_SEQUENCE", $sformatf("printing from sequence \n %s", req.sprint()), UVM_HIGH)
    finish_item(req);
  endtask

endclass
