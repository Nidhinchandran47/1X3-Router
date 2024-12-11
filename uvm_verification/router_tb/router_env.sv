class router_env extends uvm_env;

  `uvm_component_utils(router_env)

  router_source_agt_top sagt_top;
  router_dest_agt_top dagt_top;
  router_virtual_sequencer v_sequencer;
  router_scoreboard sb;

  router_env_config m_cfg;

  function new(string name = "router_env", uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg))
      `uvm_fatal("CONFIG", "cannot get() m_cfg from uvm_config_db. Have you set() it?")
    if (m_cfg.has_source_agent) sagt_top = router_source_agt_top::type_id::create("sagt_top", this);
    if (m_cfg.has_dest_agent) dagt_top = router_dest_agt_top::type_id::create("dagt_top", this);
    if (m_cfg.has_virtual_sequencer)
      v_sequencer = router_virtual_sequencer::type_id::create("v_sequencer", this);
    if (m_cfg.has_scoreboard) sb = router_scoreboard::type_id::create("sb", this);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    if (m_cfg.has_virtual_sequencer) begin
      if (m_cfg.has_source_agent) begin
        foreach (m_cfg.m_src_agent_cfg[i]) begin
          v_sequencer.src_seqrh[i] = sagt_top.agenth[i].seqrh;
        end
      end
      if (m_cfg.has_dest_agent) begin
        foreach (m_cfg.m_dest_agent_cfg[i]) begin
          v_sequencer.dst_seqrh[i] = dagt_top.agenth[i].seqrh;
        end
      end
    end
    if (m_cfg.has_scoreboard) begin
      if (m_cfg.has_source_agent) begin
        foreach (m_cfg.m_src_agent_cfg[i]) begin
          sagt_top.agenth[i].monh.monitor_port.connect(sb.fifo_src.analysis_export);
        end
      end
      if (m_cfg.has_dest_agent) begin
        foreach (m_cfg.m_dest_agent_cfg[i]) begin
          dagt_top.agenth[i].monh.monitor_port.connect(sb.fifo_dst[i].analysis_export);
        end
      end
    end
  endfunction

endclass

