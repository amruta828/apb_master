class apb_environment extends uvm_env;
  apb_scoreboard scb;
 // apb_subscriber cov;
  apb_passive_agent p_agent;
  apb_active_agent a_agent;
  `uvm_component_utils(apb_environment)
  
  function new(string name="apb_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    scb=apb_scoreboard::type_id::create("scb",this);
//    cov=apb_subscriber::type_id::create("cov",this);
     uvm_config_db#(uvm_active_passive_enum)::set(this, "a_agent", "is_active", UVM_ACTIVE);
     uvm_config_db#(uvm_active_passive_enum)::set(this, "p_agent", "is_active", UVM_PASSIVE);
    p_agent=apb_passive_agent::type_id::create("p_agent",this);
    a_agent=apb_active_agent::type_id::create("a_agent",this);
  
    
  endfunction
//   function void connect_phase(uvm_phase phase);
//   super.connect_phase(phase);

//   `uvm_info("ENV", $sformatf("a_agent=%p", a_agent), UVM_LOW)
//   if (a_agent != null)
//     `uvm_info("ENV", $sformatf("act_mon=%p", a_agent.act_mon), UVM_LOW)

//   `uvm_info("ENV", $sformatf("scb=%p", scb), UVM_LOW)
//   `uvm_info("ENV", $sformatf("scb.a_mon=%p", scb.a_mon), UVM_LOW)

//   a_agent.act_mon.mon_act_port.connect(scb.a_mon.analysis_export);
//   p_agent.pass_mon.mon_pas_port.connect(scb.p_mon.analysis_export);

// endfunction

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    //active monitor to fifo
//    a_agent.act_mon.mon_act_port.connect(cov.a_mon.analysis_export);
    a_agent.act_mon.mon_act_port.connect(scb.a_mon.analysis_export);
    
    //passive monitor to fifo
  //  p_agent.pass_mon.mon_pas_port.connect(cov.p_mon.analysis_export);
    p_agent.pass_mon.mon_pas_port.connect(scb.p_mon.analysis_export);
    
  endfunction
endclass
