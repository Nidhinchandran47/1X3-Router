# 1X3-Router

Router is a device that forward data packet between computer networks. This router have 1 source port and 3 destination port, switch packets to destination according to address. The router efficiently routes data based on predefined conditions or protocols, ensuring seamless communication across connected networks.

## Features

- **Single Soure 3 Destination** : Routes data from one input port to three distinct output ports.
- **Custom Packet Format** : Frame consist of 3 part, `Header`, `Payload` and `Parity`. Each of 32 bit and varible length payload.
- **Parity Check** : Detect error to ensure the data transmitted without getting corrupted.
- **16 wide FIFO** : Able to store upto 16 packect in each destination, waiting read enable signal.
- **Soft reset** : Automatically reset the FIFO which is waiting for enable signal for longer than 30 clock cycles.

## Interface

| Port      | Direction | Width | Function                         |
| --------- | --------- | ----- | -------------------------------- |
| clk       | input     | 1     | Triger events at positive edge   |
| pkt_valid | input     | 1     | High when new packet is arriving |
| resetn    | input     | 1     | Active low synchronous reset     |
