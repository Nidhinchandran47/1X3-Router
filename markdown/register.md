# Register

🏠[Home](README.md)

[🔗Link to file](../rtl/router_regi.v)

This module implements 4 internal registers to hold the `header byte`, `controller state byte`, `internal parity byte`, and `packet parity byte`.

## Interface

| Port          | Direction | Width | From/To      | Function                                                                |
| ------------- | --------- | ----- | ------------ | ----------------------------------------------------------------------- |
| clock         | input     | 1     | External     | Synchronize operations at positive edge                                 |
| resetn        | input     | 1     | External     | Active low signal from user to reset the module                         |
| pkt_valid     | input     | 1     | External     | User input which has a positive rise when a new header packet arrives   |
| fifo_full     | input     | 1     | Synchronizer | Indicate the destination FIFO is full                                   |
| rst_int_reg   | input     | 1     | Controller   | Used to set `low_pkt_valid`                                             |
| detect_add    | input     | 1     | Controller   | Used to identify the state of new packet arrival, to set the registers  |
| ld_state      | input     | 1     | Controller   | Indicate the load state, to set parity and `low_pkt_valid`              |
| laf_state     | input     | 1     | Controller   | Indicate load after full state, used to set output condition            |
| full_state    | input     | 1     | Controller   | Indicate full state                                                     |
| lfd_state     | input     | 1     | Controller   | Indicate load first data state, required to find header byte            |
| data_in       | input     | 8     | External     | Input data from User                                                    |
| parity_done   | output    | 1     | Controller   | Output high when packet parity matches with calculated parity           |
| low_pkt_valid | output    | 1     | Controller   | Show that `pkt_valid` for current packet has been deasserted            |
| err           | output    | 1     | External     | Output high when packet parity mismatches with calculated parity        |
| dout          | output    | 8     | FIFO         | Switch packet to destination FIFO                                       |

## Operation

### Internal Registering

- `header_reg` will latch the first byte of the packet.
- `fifo_full_reg` will latch the current input packet.
- `internal_prt_reg` will latch the result of the parity check for that packet.
- `packet_prt_reg` will latch the last packet's parity.

### Parity Checking 

An XOR-based (even parity) operation is done to ensure error checking. The `parity_done` signal will be high when the last packet (parity) is arrived and stored in the packet parity register. The `err` signal is set when there is a mismatch between the calculated parity in `internal_prt_reg` and `packet_prt_reg`.

🏠[Home](README.md)