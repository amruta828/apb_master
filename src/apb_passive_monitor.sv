
class apb_passive_monitor extends uvm_monitor;
  
  virtual apb_interface vif;
  apb_seq_item req;
  
  
  uvm_analysis_port#(apb_seq_item) mon_pas_port;
  
  `uvm_component_utils(apb_passive_monitor)
  
  function new(string name="apb_passive_monitor",uvm_component parent);
    super.new(name,parent);
    mon_pas_port = new("mon_pas_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
      `uvm_fatal("MONITOR-VIF","virtual interface not set");
  endfunction
  
 
  
  task monitor();
    req = apb_seq_item::type_id::create("req", this);

    req.PADDR         = vif.mon_cb.PADDR;
    req.PSEL          = vif.mon_cb.PSEL;
    req.PENABLE       = vif.mon_cb.PENABLE;
    req.PWRITE        = vif.mon_cb.PWRITE;
    req.PWDATA        = vif.mon_cb.PWDATA;
    req.PSTRB         = vif.mon_cb.PSTRB;
    req.rdata_out     = vif.mon_cb.rdata_out;
    req.transfer_done = vif.transfer_done;
    req.error         = vif.mon_cb.error;
    `uvm_info("PASSIVE-MONITOR", $sformatf("Got paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata_out = %od transfer_done=%0d error=%0d",req.PADDR,req.PSEL,req.PENABLE,req.PWRITE,req.PWDATA,req.PSTRB,req.rdata_out,req.transfer_done,req.error), UVM_LOW)

    mon_pas_port.write(req);
     repeat(1) @(vif.mon_cb);
  endtask
      
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(4) @(vif.mon_cb);
    forever 
      begin
      monitor();
    end
  endtask
  
endclass

    
