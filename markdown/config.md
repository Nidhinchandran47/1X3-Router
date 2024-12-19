# Configuration Database

🏠[Home](../README.md)  🔙 [Back](verification.md)

[**🔗 Environent Config**](../uvm_verification/router_tb/router_env_config.sv)

[**🔗 Source Config**](../uvm_verification/router_source/source_agent_config.sv)

[**🔗 Destination Config**](../uvm_verification/router_destination/dest_agent_config.sv)

The UVM configuration database (config_db) is used to store and retrieve configuration settings across different UVM components. It enables dynamic and hierarchical passing of parameters, such as simulation settings or testbench configurations, without hardcoding them. This promotes flexibility and reusability in testbench design.

#### Environment

- Contain varibles governing Testbench Architecture 
  - `has_scoreboard`, `has_source_agent`, `has_dest_agent` and `has_virtual_sequencer`
  - `number_of_source` and `number_of_dest`
- Contain Handle of other config dbs

#### Agent

- Contain Virtual containing interface
- `uvm_active_passive_enum` to control Active or Passive
  - Active : Contain Monitor, Driver and Sequencer
  - Passive : Only contain Monitor
- Contain some static varibles to count transactions