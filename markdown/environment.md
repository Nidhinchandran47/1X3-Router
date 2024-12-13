# Environment

🏠[Home](../README.md)  🔙 [Back](verification.md)

[**🔗Link to File**](../uvm_verification/router_tb/router_env.sv)

### Functions

- Building Source agent top, Destination agent top, Scoreboard and Virtual sequencer according to environment configuration set from top module.

```sv
if (m_cfg.has_source_agent) 
    sagt_top = router_source_agt_top::type_id::create("sagt_top", this);
```

- Make connection between local sequencer and virtual sequencer and analysis port connection between monitor and score board.

```sv
if (m_cfg.has_scoreboard) begin
  if (m_cfg.has_source_agent) begin
    foreach (m_cfg.m_src_agent_cfg[i]) begin
        sagt_top.agenth[i].monh.monitor_port.connect(sb.fifo_src.analysis_export);
    end
  end
end
```
