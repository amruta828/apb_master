class apb_passive_agent extends uvm_agent;
  apb_passive_monitor pass_mon;
  
  `uvm_component_utils(apb_passive_agent)
  
  function new(string name="apb_passive_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  if(get_is_active() == UVM_PASSIVE) 
      begin 
        pass_mon=apb_passive_monitor::type_id::create("pass_mon",this);
      end 
  endfunction  
endclass
