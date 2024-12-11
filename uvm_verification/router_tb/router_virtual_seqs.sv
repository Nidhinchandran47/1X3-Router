class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(router_vbase_seq)

  router_source_sequencer src_seqrh[];
  router_dest_sequencer dst_seqrh[];
  router_virtual_sequencer vsqrh;
  router_env_config m_cfg;

  function new(string name = "router_vbase_seq");
    super.new(name);
  endfunction

  task body();
    if (!uvm_config_db#(router_env_config)::get(null, get_full_name(), "router_env_config", m_cfg))
      `uvm_fatal("get_type_name()", "cannot get cfg")
    src_seqrh = new[m_cfg.number_of_source];
    dst_seqrh = new[m_cfg.number_of_dest];
    assert ($cast(vsqrh, m_sequencer))
    else begin
      `uvm_error("BODY", "error in $cast")
    end
    foreach (src_seqrh[i]) begin
        src_seqrh[i] = vsqrh.src_seqrh[i];
    end
    foreach (dst_seqrh[i]) begin
        dst_seqrh[i] = vsqrh.dst_seqrh[i];
    end
  endtask

endclass

// small packet

class router_small_vseq extends router_vbase_seq;

  `uvm_object_utils(router_small_vseq)

  bit [1:0] addr;

  small_seq src_seq;
  small_dseq dst_seq;

  function new(string name ="router_small_vseq");
    super.new(name);
  endfunction

  task body();
    super.body();
    if (!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(), "cannot get cfg")
    src_seq = small_seq::type_id::create("src_seq");
    dst_seq = small_dseq::type_id::create("dst_seq");
    fork
      src_seq.start(src_seqrh[0]);
      dst_seq.start(dst_seqrh[addr]);
    join
  endtask
endclass

//medium packet

class router_med_vseq extends router_vbase_seq;

  `uvm_object_utils(router_med_vseq)

  bit [1:0] addr;

  med_seq src_seq;
  small_dseq dst_seq;

  function new(string name ="router_med_vseq");
    super.new(name);
  endfunction

  task body();
    super.body();
    if (!uvm_config_db#(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
      `uvm_fatal(get_type_name(), "cannot get cfg")
    src_seq = med_seq::type_id::create("src_seq");
    dst_seq = small_dseq::type_id::create("dst_seq");
    fork
      src_seq.start(src_seqrh[0]);
      dst_seq.start(dst_seqrh[addr]);
    join
  endtask
endclass

// big packet


class router_big_vseq extends router_vbase_seq;

  `uvm_object_utils(router_big_vseq)

  bit [1:0] addr;

  big_seq src_seq;
  small_dseq dst_seq;

  function new(string name ="router_big_vseq");
    super.new(name);
  endfunction

  task body();
    super.body();
    if (!uvm_config_db#(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
      `uvm_fatal(get_type_name(), "cannot get cfg")
    src_seq = big_seq::type_id::create("src_seq");
    dst_seq = small_dseq::type_id::create("dst_seq");
    fork
      src_seq.start(src_seqrh[0]);
      dst_seq.start(dst_seqrh[addr]);
    join
  endtask
endclass

//soft reset packet


class router_soft_vseq extends router_vbase_seq;

  `uvm_object_utils(router_soft_vseq)

  bit [1:0] addr;

  small_seq src_seq;
  delay_dseq dst_seq;

  function new(string name ="router_soft_vseq");
    super.new(name);
  endfunction

  task body();
    super.body();
    if (!uvm_config_db#(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
      `uvm_fatal(get_type_name(), "cannot get cfg")
    src_seq = small_seq::type_id::create("src_seq");
    dst_seq = delay_dseq::type_id::create("dst_seq");
    fork
      src_seq.start(src_seqrh[0]);
      dst_seq.start(dst_seqrh[addr]);
    join
  endtask
endclass
