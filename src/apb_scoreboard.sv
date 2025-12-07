class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_tlm_analysis_fifo#(apb_seq_item)a_mon;
  uvm_tlm_analysis_fifo#(apb_seq_item)p_mon;
  
  apb_seq_item act_mon_item,pas_mon_item;
  apb_seq_item expected_item;
  

  bit setup,access;
  bit [7:0]addr_store;
  bit [31:0]wdata_store;
  bit [3:0]strb_store;
  bit write_read_store;
  int match_count,mismatch_count;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    a_mon=new("a_mon",this);
    p_mon=new("p_mon",this);
  endfunction
  
  task assign_values(apb_seq_item act_mon_item,apb_seq_item expected);
    if(act_mon_item.PRESETn==0)begin
      expected_item.PADDR=0;
    expected_item.PSEL=0;
    expected_item.PENABLE=0;
    expected_item.PWDATA=0;
    expected_item.PSTRB=0;
      expected_item.PWRITE=0;
    expected_item.rdata_out=0;
    expected_item.transfer_done=0;
    expected_item.error=0;
      setup=0;
    end
    else if(act_mon_item.transfer==0)begin
      
    expected_item.PADDR=0;
    expected_item.PSEL=0;
    expected_item.PENABLE=0;
    expected_item.PWDATA=0;
    expected_item.PSTRB=0;
      expected_item.PWRITE=0;
    expected_item.rdata_out=0;
    expected_item.transfer_done=0;
    expected_item.error=0;
      setup=0;
    end
    else if(act_mon_item.transfer==1 )
      setup=1;
    
    if(act_mon_item.transfer==1 && setup==1)
    begin
       			  addr_store = act_mon_item.addr_in;  
                  wdata_store = act_mon_item.wdata_in;
                  strb_store = act_mon_item.strb_in;
                  write_read_store = act_mon_item.write_read;
                 
    expected_item.PSEL=1;
    expected_item.PWRITE=write_read_store;
    expected_item.PENABLE=0;
    expected_item.PADDR=addr_store;
    
      if(act_mon_item.write_read)begin
        expected_item.PWDATA=wdata_store;
      expected_item.PSTRB=strb_store;
      end
      else begin
      expected_item.PWDATA=0;
      expected_item.PSTRB=0;
      end
      expected_item.transfer_done=0;
      expected_item.error=0;
      
      expected_item.rdata_out=0;
       access=1;
    end
   
      
    else if(act_mon_item.transfer==1 && access==1)begin
         expected_item.PSEL=1;
    expected_item.PWRITE=write_read_store;
    expected_item.PENABLE=1;
    expected_item.PADDR=addr_store;
        
      if(write_read_store)begin
          expected_item.PWDATA=wdata_store;
      expected_item.PSTRB=strb_store;
        end
        else begin 
          expected_item.PWDATA=0;
        expected_item.PSTRB=0;
        end
      end
        
        if(act_mon_item.PREADY)begin
            expected_item.transfer_done = 1;
          
            if(write_read_store == 0) begin
            expected_item.rdata_out = act_mon_item.PRDATA;
           end 
          else begin
            expected_item.rdata_out = 0;
           end
          
            if(act_mon_item.PSLVERR == 1) begin
            expected_item.error = 1;
           end 
          else begin
            expected_item.error = 0;
           end
        end
        else begin
           expected_item.transfer_done = 0;
           expected_item.rdata_out = 0;
           expected_item.error = 0;
          end
          
    compare(expected_item,pas_mon_item);
  endtask
  
  
 
  
  task compare(input apb_seq_item expected_item, input apb_seq_item pas_mon_item);
    bit mismatch = 0;
    if(expected_item.PADDR !== pas_mon_item.PADDR) begin
      `uvm_error(get_full_name(), $sformatf("PADDR MISMATCH---- Expected=%0d Actual=%0d", expected_item.PADDR, pas_mon_item.PADDR))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PADDR MATCH=== Expected=%0d Actual=%0d", expected_item.PADDR, pas_mon_item.PADDR),UVM_LOW)
    end
    
    if(expected_item.PSEL !== pas_mon_item.PSEL) begin
      `uvm_error(get_full_name(), $sformatf("PSEL MISMATCH-----  Expected=%0d Actual=%0d", expected_item.PSEL, pas_mon_item.PSEL))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PSEL MATCH==== Expected=%0d Actual=%0d", expected_item.PSEL, pas_mon_item.PSEL),UVM_LOW)
    end
    
    if(expected_item.PENABLE !== pas_mon_item.PENABLE) begin
      `uvm_error(get_full_name(), $sformatf("PENABLE MISMATCH----- Expected=%0d  Actual=%0d", expected_item.PENABLE, pas_mon_item.PENABLE))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PENABLE MATCH==== Expected=%0d  Actual=%0d", expected_item.PENABLE, pas_mon_item.PENABLE),UVM_LOW)
    end
    
    if(expected_item.PWRITE !== pas_mon_item.PWRITE) begin
      `uvm_error(get_full_name(), $sformatf("PWRITE MISMATCH--- Expected=%0d | Actual=%0d", expected_item.PWRITE, pas_mon_item.PWRITE))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PWRITE MATCH ====== Expected=%0d Actual=%0d", expected_item.PWRITE, pas_mon_item.PWRITE),UVM_LOW)
    end
    
    if(expected_item.PWDATA !== pas_mon_item.PWDATA) begin
      `uvm_error(get_full_name(), $sformatf("PWDATA MISMATCH ------ Expected=%0d  Actual=%0d", expected_item.PWDATA, pas_mon_item.PWDATA))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PWDATA MATCH ===== Expected=%0d  Actual=%0d", expected_item.PWDATA, pas_mon_item.PWDATA),UVM_LOW)
    end
    
    if(expected_item.PSTRB !== pas_mon_item.PSTRB) begin
      `uvm_error(get_full_name(), $sformatf("PSTRB MISMATCH ---- Expected=%0d  Actual=%0d", expected_item.PSTRB, pas_mon_item.PSTRB))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("PSTRB MATCH ==== Expected=%0d Actual=%0d", expected_item.PSTRB, pas_mon_item.PSTRB),UVM_LOW)
    end
    
    if(expected_item.transfer_done !== pas_mon_item.transfer_done) begin
      `uvm_error(get_full_name(), $sformatf("TRANSFER_DONE MISMATCH ----- Expected=%0d Actual=%0d", expected_item.transfer_done, pas_mon_item.transfer_done))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("TRANSFER_DONE MATCH ==== Expected=%0d  Actual=%0d", expected_item.transfer_done, pas_mon_item.transfer_done),UVM_LOW)
    end
    
    if(expected_item.error !== pas_mon_item.error) begin
      `uvm_error(get_full_name(), $sformatf("ERROR MISMATCH ----- Expected=%0d  Actual=%0d", expected_item.error, pas_mon_item.error))
      mismatch = 1;
    end
    else  begin
      `uvm_info(get_full_name(), $sformatf("ERROR MATCH ===== Expected=%0d Actual=%0d", expected_item.error, pas_mon_item.error),UVM_LOW)
    end
    
    if(expected_item.write_read==0 && expected_item.transfer_done == 1) begin
      if(expected_item.rdata_out !== pas_mon_item.rdata_out) begin
        `uvm_error(get_full_name(), $sformatf("RDATA_OUT MISMATCH ------- Expected=%0d Actual=%0d", expected_item.rdata_out, pas_mon_item.rdata_out))
        mismatch = 1;
      end
      else  begin
        `uvm_info(get_full_name(), $sformatf("RDATA_OUT MATCH ====== Expected=%0d Actual=%0d", expected_item.rdata_out, pas_mon_item.rdata_out),UVM_LOW)
    end
    end
    
    if(mismatch) begin
      `uvm_info(get_full_name(), $sformatf("RDATA_OUT MATCH ====== Expected=%0d  Actual=%0d", expected_item.rdata_out, pas_mon_item.rdata_out),UVM_LOW)
    end
    
    
    if(mismatch) 
      mismatch_count++;
     
    else begin
      match_count++;
      `uvm_info(get_full_name(), $sformatf("=== TRANSACTION PASSED ==="), UVM_MEDIUM)
    end

  endtask
  
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    expected_item=apb_seq_item::type_id::create("expected_item");
    forever
    begin
      fork
        a_mon.get(act_mon_item);
        p_mon.get(pas_mon_item);
      join
      assign_values(act_mon_item,pas_mon_item);
    end
  endtask
  
endclass
