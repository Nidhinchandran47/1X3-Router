# Register

🏠[Home](README.md)

This module implements 4 internal registers to hold the `header byte`, `controller state byte`, `internal parity byte` and `packet parity byte`.

## Interface

| Port       | Direction | Width | From/To           | Function                                         |
| ---------- | --------- | ----- | ----------------- | ------------------------------------------------ |
| clock | input | 1 | External | Synchronize operations at positive edge |
| resetn |output | 1 | External | Active low signal from user to reset the module |
| pkt_valid | input | 1 | External | User input which have a positive rise when new header packet arrive |
| fifo_full | input | 1 | | |
| rst_int_reg | input | 1 | | |
| detect_add | input | 1 | | |
| ld_state | input | 1 | | |
| laf_state | input | 1 | | |
| full_state | input | 1 | | |
| lfd_state | input | 1 | | |
| data_in | input | 8 | External | |
| parity_done | output | 1 | Controller | |
| low_pkt_valid | output| 1 | Controller | |
| err | output | 1 | External | |
| dout | output | 8 | FIFO | |


🏠[Home](README.md)