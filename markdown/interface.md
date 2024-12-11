# Interface

In SystemVerilog, an **interface** is a construct used to group related signals together, simplifying connections between modules and testbenches. It encapsulates signals, tasks, and functions, promoting modularity and reusability while reducing code complexity.

[link to file](../rtl/router_if.sv)

Here we have 4 Modport which connect design to Monitor and Driver of Source and 3 Destination.

- SRC_DRV_MP
- SRC_MON_MP
- DEST_DRV_MP
- DEST_MON_MP

Each Modport contain clocking block which groups relative signals and provide sensitivity edge and driving delays.
  
From top module, we are calling 4 instance of interface each for 1 Source and 3 Destination.