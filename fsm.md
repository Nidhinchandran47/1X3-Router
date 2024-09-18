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
| pkt_valid | . | . | . | . |
| parity_done | . | . | . | . |
| data_in | . | . | . | . |
| soft_reset_0 | . | . | . | . |
| soft_reset_1 | . | . | . | . |
| soft_reset_2 | . | . | . | . |
| fifo_full | . | . | . | . |
| low_packet_valid | . | . | . | . |
| fifo_empty_0 | . | . | . | . |
| fifo_empty_1 | . | . | . | . |
| fifo_empty_2 | . | . | . | . |
| busy | . | . | . | . |
| detect_add | . | . | . | . |
| ld_state | . | . | . | . |
| laf_state | . | . | . | . |
| full_state | . | . | . | . |
| write_enb_reg | . | . | . | . |
| rst_int_reg | . | . | . | . |
| lfd_state | . | . | . | . |


🏠[Home](README.md)