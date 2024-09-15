# Register

🏠[Home](README.md)

This module implements 4 internal registers to hold the `header byte`, `controller state byte`, `internal parity byte` and `packet parity byte`.

## Interface

| Port          | Direction | Width | From/To      | Function                                                                |
| ------------- | --------- | ----- | ------------ | ----------------------------------------------------------------------- |
| clock         | input     | 1     | External     | Synchronize operations at positive edge                                 |
| resetn        | output    | 1     | External     | Active low signal from user to reset the module                         |
| pkt_valid     | input     | 1     | External     | User input which have a positive rise when new header packet arrive     |
| fifo_full     | input     | 1     | Synchronizer | Indicate the destination FIFO is full                                   |
| rst_int_reg   | input     | 1     | Controller   | Used to set `low_packet_vaild`                                          |
| detect_add    | input     | 1     | Controller   | Used to indentify the state of new packet arrival, to set the registers |
| ld_state      | input     | 1     | Controller   | Indicate the load state, to set parity and `low_packet_vaild`           |
| laf_state     | input     | 1     | Controller   | Indicate load after full state, used to set output condition            |
| full_state    | input     | 1     | Controller   | Indicate full state                                                     |
| lfd_state     | input     | 1     | Controller   | Indicate load first data state, required to find header byte            |
| data_in       | input     | 8     | External     | Input data from User                                                    |
| parity_done   | output    | 1     | Controller   | Output high when packet parity match with calculated parity             |
| low_pkt_valid | output    | 1     | Controller   | Show that `pkt_valid` for current packet has been deasserted            |
| err           | output    | 1     | External     | Output high when packet parity mismatch with calculated parity          |
| dout          | output    | 8     | FIFO         | Switch packet to destination FIFO                                       |

## Operation

### Intenal Registering

- `header_reg` will latch the first byte of the packet.
- `fifo_full_reg` will latch the current input packet.
- `internal_prt_reg` will latch the answer of parity check till that packet.
- `packet_prt_reg` will latch last pscket, packet parity.

### Parity checking 

An exor based (even parity) operation is done to ensure the error checking, parity_done signal will be high when last packet (parity) is arrived and stored to packet parity reg. Then set the err signal when there is a mismatch with calculated parity in internal_prt_reg and packet_prt_reg.

🏠[Home](README.md)