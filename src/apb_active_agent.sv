class apb_active_agent extends uvm_agent;
  apb_driver drv;
  apb_active_monitor act_mon;
  apb_sequencer seqr;
  
  `uvm_component_utils(apb_active_agent)
  
  function new(string name="apb_active_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   
           drv=apb_driver::type_id::create("drv",this);
           act_mon=apb_active_monitor::type_id::create("act_mon",this);
           seqr=apb_sequencer::type_id::create("seqr",this);
         
   endfunction
       
   function void connect_phase(uvm_phase phase);
     if(get_is_active()==UVM_ACTIVE)
       begin
         drv.seq_item_port.connect(seqr.seq_item_export);
       end
   endfunction
  
//   function void connect_phase(uvm_phase phase);
//   super.connect_phase(phase);
//   `uvm_info("AGENT", $sformatf("get_is_active()=%0p", get_is_active()), UVM_LOW);
//   drv.seq_item_port.connect(seqr.seq_item_export);
//   `uvm_info("AGENT", $sformatf("Connected drv.seq_item_port=%0p to seqr.seq_item_export=%0p", drv.seq_item_port, seqr.seq_item_export), UVM_LOW);
// endfunction

       
 endclass
         
    
