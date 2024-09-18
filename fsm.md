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
| pkt_valid | input | 1  | External | Indicated the data in is valid |
| parity_done | input | 1  | External  | Indicate the parity calculation completed |
| data_in | input | 2 | External | First 2 bits of input packet |
| soft_reset_0 | input | 1  | Synchronizer | Internal signal to reset FIFO 0 |
| soft_reset_1 | input | 1  | Synchronizer  | Internal signal to reset FIFO 1 |
| soft_reset_2 | input | 1  | Synchronizer  | Internal signal to reset FIFO 2 |
| fifo_full | input | 1  | Synchronizer | Indicate the FIFO at current desstination is full |
| low_packet_valid | input | 1  | Register | Show the register status `packet valid` |
| fifo_empty_0 | input | 1  | FIFO 0 | Indicate FIFO 0 is empty (new header packet will assgin only if empty) |
| fifo_empty_1 | input | 1  | FIFO 1 | ndicate FIFO 1 is empty (new header packet will assgin only if empty). |
| fifo_empty_2 | input | 1  | FIFO 2 | ndicate FIFO 2 is empty (new header packet will assgin only if empty). |
| busy | output | 1  | External | Stop the user from inputing data. |
| detect_add | output | 1  | Register, Sync. | Indicate system is in the state to detect address. |
| ld_state | output  | 1  | Register | Indicate system is in the state of loading payload. |
| laf_state | output  | 1  | Register | High when destination fifo get write space after begin full. |
| full_state | output  | 1  | Register | Indicate the system is in wait state due to fifo full. |
| write_enb_reg | output  | 1  | Synchronizer | Used to set synchronizer state. |
| rst_int_reg | output  | 1  | Register | Used to set register state. |
| lfd_state | output  | 1 | FIFO, Register | Indicate the system is in state of loading header. |

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> DECODE_ADDRESS : ~ reset
    DECODE_ADDRESS --> LOAD_FIRST_DATA : pkt_valid & fifo_empty @ destination
    DECODE_ADDRESS --> WAIT_TILL_EMPTY : pkt_valid & !fifo_empty @ destination
    WAIT_TILL_EMPTY --> LOAD_FIRST_DATA : fifo_empty @ dest
    LOAD_FIRST_DATA --> LOAD_DATA
    LOAD_DATA --> LOAD_PARITY : !fifo_full & !pkt_valid
    LOAD_DATA --> FIFO_FULL_STATE : fifo_full
    LOAD_PARITY --> CHECK_PARITY_ERROR
    CHECK_PARITY_ERROR --> FIFO_FULL_STATE : fifo_full
    CHECK_PARITY_ERROR --> DECODE_ADDRESS : !fifo_full
    FIFO_FULL_STATE --> LOAD_AFTER_FULL : !fifo_full
    FIFO_FULL_STATE --> FIFO_FULL_STATE : fifo_full
    LOAD_AFTER_FULL --> DECODE_ADDRESS : parity_done
    LOAD_AFTER_FULL --> LOAD_PARITY : !parity_done & low_packet_valid
    LOAD_AFTER_FULL -->  LOAD_DATA :  !parity_done & !low_packet_valid
```

🏠[Home](README.md)