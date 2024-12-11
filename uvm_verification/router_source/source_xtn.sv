class source_xtn extends uvm_sequence_item;

  `uvm_object_utils(source_xtn)

  rand bit [7:0] header;
  rand bit [7:0] payload[];
  bit [7:0] parity;
  bit error;
  //bit busy;

  constraint payload_size_c {payload.size == header[7:2];}
  constraint payload_limit_c {header[7:2] != 0;}
  constraint address_limit_c {header[1:0] != 3;} 

  extern function new(string name = "source_xtn");
  extern function void do_print(uvm_printer printer);
  extern function void post_randomize();
endclass

function source_xtn::new(string name = "source_xtn");
  super.new(name);
endfunction

function void source_xtn::do_print(uvm_printer printer);

  printer.print_field("header", this.header, 8, UVM_BIN);
  printer.print_field("address", this.header[1:0], 2, UVM_DEC);
  printer.print_field("length", this.header[7:2], 6, UVM_DEC);
  foreach (payload[i])
    printer.print_field($sformatf("payload[%0d]", i), this.payload[i], 8, UVM_DEC);
  printer.print_field("parity", this.parity, 8, UVM_DEC);
  printer.print_field("error", this.error, 1, UVM_BIN);

endfunction

function void source_xtn::post_randomize();
  parity = header ^ 8'h00;
  foreach (payload[i])
    parity = payload[i] ^ parity;
endfunction

class error_xtn extends source_xtn;

  `uvm_object_utils(error_xtn)

  function new(string name = "error_xtn");
    super.new(name);
  endfunction

  function void post_randomize();
  parity = header ^ 8'h00;
  foreach (payload[i])
    parity = payload[i] ^ parity;
    parity = parity + 1;
  endfunction

endclass
