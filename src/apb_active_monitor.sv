class apb_active_monitor extends uvm_monitor;
  
  virtual apb_interface vif;

  apb_seq_item req;                      
  uvm_analysis_port#(apb_seq_item) mon_act_port;  
  
  `uvm_component_utils(apb_active_monitor)
  
  function new(string name="apb_active_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
        
    if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
      `uvm_fatal("MONITOR-VIF","virtual interface not set");

    mon_act_port = new("mon_act_port", this);   
  endfunction
  
  
  task monitor();
    req = apb_seq_item::type_id::create("req", this);
    
    req.transfer     = vif.mon_cb.transfer;
    req.PRESETn     = vif.mon_cb.PRESETn;
    req.strb_in      = vif.mon_cb.strb_in;
    req.wdata_in     = vif.mon_cb.wdata_in;
    req.write_read   = vif.mon_cb.write_read;
    req.addr_in      = vif.mon_cb.addr_in;
    req.PREADY       = vif.mon_cb.PREADY;
    req.PSLVERR      = vif.mon_cb.PSLVERR;
    req.PRDATA       = vif.mon_cb.PRDATA;
    `uvm_info("ACTIVE-MONITOR", $sformatf("Got : transfer=%0d reset=%0d strb_in=%0d wdata_in=%0d write_read=%0d adddr_in=%0d pready = %od pslverr=%0d prdata=%0d",req.transfer,req.PRESETn,req.strb_in,req.wdata_in,req.write_read,req.addr_in,req.PREADY,req.PSLVERR,req.PRDATA), UVM_LOW)
     mon_act_port.write(req);
    
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
