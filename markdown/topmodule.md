# Top Module

🏠[Home](../README.md)  🔙 [Back](verification.md)

[**🔗Link to File**](../uvm_verification/router_tb/top.sv)

Import Package including all files in this project

```sv
import router_pkg::*;
```

Create 4 instance interface for 1 Source and 3 Destination as `in_s`, `in_d0`, `in_d1` and `in_d2`. Connect the DUV (design) with interface.

Setting interface details to configuration database to connect it with virtual interface.
```sv
uvm_config_db#(virtual router_if)::set(null, "*", "vifs_0", in_s);
uvm_config_db#(virtual router_if)::set(null, "*", "vifd_0", in_d0);
uvm_config_db#(virtual router_if)::set(null, "*", "vifd_1", in_d1);
uvm_config_db#(virtual router_if)::set(null, "*", "vifd_2", in_d2);
```

### Assertions

An assertion is a check in hardware verification that ensures a design's behavior matches the expected protocol or functionality during simulation.

1. pkt_valid_busy
        
    - check busy is high just after packet valid goes high.
1. busy_datain

    - check datain doesnot change when busy is high.
2. readx

    - check read enable goes high within 30 cycles after valid out of an output goes high.
3. lowreadx

    - check read enable is low just after valid out goes low.