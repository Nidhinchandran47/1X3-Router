# Synchronizer

Provide Synchronization between router FSM and FIFO modules.

## Interface

| Port       | Direction | Width | From/To           | Function                                         |
| ---------- | --------- | ----- | ----------------- | ------------------------------------------------ |
| clock      | input     | 1     | External          | Synchronize the operations at positive edge      |
| resetn     | input     | 1     | External          | Active low reset given from source               |
| write_enb_reg | input | 1 | FSM | Indicate write enable to update |
| detect_add | input | 1 | FSM | Indicate fifo address to update(high when new packet arrive, to take address from first two bits of data in) |
| read_enb_`x` | input | 1 | External | Indicate destination is reading from FIFO_`x` |
| empty_`x` | input | 1 | FIFO_`x` | Show FIFO_`x` is empty |
| full_`x` | input | 1 | FIFO_`x` | Show FIFO_`x` is full |
| data_in | input | 2 | External | First two bits of input data, contain destination address in first packet |
| vld_out_`x` | output | 1 | External | Indicate the data from FIFO is valid or not |
| soft_reset_`x` | output | 1 | FIFO_`x` | To reset FIFO |
| write_enb | output | 2 | FIFO | One hot encoding of destination address |