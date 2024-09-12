# 1X3-Router

Router is a device that forward data packet between computer networks. This router have 1 source port and 3 destination port, switch packets to destination according to address. The router efficiently routes data based on predefined conditions or protocols, ensuring seamless communication across connected networks.

## Features

- **Single Soure 3 Destination** : Routes data from one input port to three distinct output ports.
- **Custom Packet Format** : Frame consist of 3 part, `Header`, `Payload` and `Parity`. Each of 32 bit and varible length payload.
- **Parity Check** : Detect error to ensure the data transmitted without getting corrupted.
- **16 wide FIFO** : Able to store upto 16 packect in each destination, waiting read enable signal.
- **Soft reset** : Automatically reset the FIFO which is waiting for enable signal for longer than 30 clock cycles.

## Interface

| Port         | Direction | Width | Function                                      |
| ------------ | --------- | ----- | --------------------------------------------  |
| clk          | input     | 1     | Triger events at positive edge                |
| pkt_valid    | input     | 1     | High when new packet is arriving (from Source network)  |
| resetn       | input     | 1     | Active low synchronous reset                  |
| data_in      | input     | 8     | Data Packet from the source                   |
| read_enb_`x` | input     | 1     | Active high signal for reading packet to `x` destination (from Destination Network) |
| data_out_`x` | output    | 8     | The transmitted packet to destination *Output*|
| valid_out_`x`| output    | 1     | Signal the output `data_out_x` is valid       |
| busy         | output    | 1     | detect busy state to stop accepting new input |
| error        | output    | 1     | Show the parity check output, high if errror  |

`x` can be `1`, `2` or `3` accodring to the destination.

## Architecture

This router consist of 4 main blocks,

- `FIFO` : to store the packets till destination is ready
- `REGISTER` : consist of 4 internal register packet switching and parity checking
- `CONTROLLER` : a FSM which generate all sorts of control signals
- `SYNCHRONIZER` : provide synchronization between register and controller

## More Details

- ### [Protocol](protocol.md)

- ### [FIFO](fifo.md)