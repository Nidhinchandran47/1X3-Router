# Controller

🏠[Home](README.md)

This module generates all the control signals when a new packet arrives. Controller consider the whole operation into 8 state.

- `Decode address`
- `Load first data`
- `Load data`
- `Load parity`
- `Check parity error`
- `Fifo full state`
- `Load after full`
- `Wait till empty`

## Interface


| Port       | Direction | Width | From/To           | Function                                         |
| ---------- | --------- | ----- | ----------------- | ------------------------------------------------ |
| clock      | input     | 1     | External          | Synchronize the operations at positive edge      |
| resetn     | input     | 1     | External          | Active low reset given from source               |
| pkt_valid | input | 1  | External | . |
| parity_done | input | 1  | External  | . |
| data_in | input | 2 | External | . |
| soft_reset_0 | input | 1  | Synchronizer | . |
| soft_reset_1 | input | 1  | Synchronizer  | . |
| soft_reset_2 | input | 1  | Synchronizer  | . |
| fifo_full | input | 1  | Synchronizer | . |
| low_packet_valid | input | 1  | Register | . |
| fifo_empty_0 | input | 1  | FIFO 0 | . |
| fifo_empty_1 | input | 1  | FIFO 1 | . |
| fifo_empty_2 | input | 1  | FIFO 2 | . |
| busy | output | 1  | External |  |
| detect_add | output | 1  | Register, Sync. | . |
| ld_state | output  | 1  | Register | . |
| laf_state | output  | 1  | Register | . |
| full_state | output  | 1  | Register | . |
| write_enb_reg | output  | 1  | Synchronizer | . |
| rst_int_reg | output  | 1  | Register | . |
| lfd_state | output  | 1 | FIFO, Register | . |


🏠[Home](README.md)