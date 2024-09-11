# Protocol

🏠[Home](README.md)

Router is an [OSI](https://en.wikipedia.org/wiki/OSI_model) layer 3 routing device. Here we are expecting a input data of custom packet format.

## Packet

Packet format cocsists of 3 parts: `Header`, `Payload` and `Parity` each of 32 bits. The `parity` can be extented between 1 packet to 63 packets

```mermaid
%%{init: {"theme": "neutral", "packet": {"bitsPerRow": 8, "rowHeight": 30, "bitWidth": 64}}}%%
---
title: "custom Packet"
---
packet-beta
  0-1: "Dest Address [0:1]"
  2-7: "Payload length [2:7]"
  8-15: "payload[0][0:7]"
  16-23: "payload[1]"
  24-31: "payload[2]"
  32-39: "payload[3]"
  40-47: "......"
  48-55: "payload[n-1]"
  56-63: "Parity"
  ```
  
**Destination Adderss** can be 

- `00` : to port 0
- `01` : to port 1
- `10` : to port 2
- `11` : invaild packet

**Payload length** can varies from $2^0$ = 1 to $2^{6}-1=63$ 

## Input Protocol

The packet valid signal should asserted onthe same clock edge when the header byte is driven. Just after the first byte `busy` will be high, so the header remain in the input for minimum of 2 clock cycle.

Do not drive any packet when a busy signal is detected, instead it should hold last driven value.

Incase of error signal, the last packet should be resented to the router.

## Output Protocol

Each outputs are buffered internally by a 16 byte fifo. Output at each data out port is vaild only if the vaild out corresponding to that output is high.

Next packet will appear only if the readenable is high, even though there is internal buffer, if the read enable is not high for 30 clock cycle, Buffer will be internally reseted.

🏠[Home](README.md)