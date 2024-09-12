# FIFO

FIFO (First In First Out) are buffer memory device store memory in queue like strcature.

There are 3 FIFOs used in this project, one in each output. It has length of 16 or it can buffer up to 16 packets. Even though each packet has a size of 8 bits, FIFO have 9 bit wide locations, extra one bit to store header information : `lfd_state`

> [!NOTE]
> in the buffer of width [8:0], data at [7:0] and lfd_state at [8].
> lfd_state is HIGH for Header and Zero for all other packets

## Interface

| Port       | Direction | Width | From/To           | Function                                         |
| ---------- | --------- | ----- | ----------------- | ------------------------------------------------ |
| clock      | input     | 1     | External          | Synchronize the operations at positive edge      |
| resetn     | input     | 1     | External          | Active low reset given from source               |
| write_enb  | input     | 1     | Synchronizer      | Control the writing process                      |
| soft_reset | input     | 1     | Synchronizer      | Reset when data is not read for 30 cycle or more |
| read_enb   | input     | 1     | External          | Control the reading process                      |
| data_in    | input     | 8     | Register          | Data need to be buffered                         |
| lfd_state  | input     | 1     | FSM               | Header packet information                        |
| empty      | output    | 1     | FSM, Synchronizer | FIFO empty                                       |
| full       | output    | 1     | Synchronizer      | FIFO full                                        |
| data_out   | output    | 8     | External          | packet to destination                            |
