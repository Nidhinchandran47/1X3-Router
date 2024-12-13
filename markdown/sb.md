# Scoreboard

🏠[Home](../README.md)  🔙 [Back](verification.md)

[**🔗Link to File**](../uvm_verification/router_tb/router_scoreboard.sv)

Scoreboard checks the functional correctness of a design. It receives expected outputs from source and destination monitors and compares. Also contain covergroup to check the coverage matrix.

### Functions

- Contain `uvm_tlm_analysis_fifo` to read from monitors.

```sv
  uvm_tlm_analysis_fifo #(source_xtn) fifo_src;
```

- Coverpoints set bins to verify output range all desired value.

```sv
P_SIZE: coverpoint cov_src_data.header[7:2] {
    bins SMALL = {[1 : 15]}; 
    bins MED = {[16 : 30]}; 
    bins BIG = {[32 : 63]};
}
```

- Read the monitor data.

```sv
fifo_src.get(src_data);
```

- Samples for coverage analysis.

```sv
router_cov1.sample();
```

- Create reference model, compare and display the result.

```sv
prt = dest_data.header ^ 0;
foreach (dest_data.payload[i]) begin
  prt = dest_data.payload[i] ^ prt;
end
...

if (prt == dest_data.parity) 
    `uvm_info("SCOREBOARD", "PARITY CHECK SUCCESSFULLY", UVM_LOW)
else 
    `uvm_info("SCOREBOARD", "ERROR IN PARITY", UVM_LOW)
```
