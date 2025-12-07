class apb_driver extends uvm_driver#(apb_seq_item);
  
  virtual apb_interface vif;
  
  `uvm_component_utils(apb_driver)
  
  bit prev_transfer;
  
  function new(string name="apb_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
      `uvm_fatal("DRIVER-VIF","virtual interface not set");
  endfunction
  
 
  
  virtual task run_phase(uvm_phase phase);
   apb_seq_item req;
    repeat(3) @(vif.drv_cb);
 forever 
   begin
     seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done();
    end
 
  endtask
  
 virtual task drive(apb_seq_item req);
//   vif.transfer<=req.transfer;
//   vif.PSEL    <= 1;
//   vif.PWRITE  <= req.write_read;
//   vif.PADDR   <= req.addr_in;
//   vif.PWDATA  <= req.wdata_in;
//   vif.PSTRB   <= req.strb_in;
//   vif.PENABLE <= 0;

//   if(req.transfer)begin
//     if(req.transfer!=prev_transfer)begin
//       prev_transfer=req.transfer;
//       repeat(2) @(vif.drv_cb);
//       if(req.PREADY)begin
//        vif.PRDATA  <= req.PRDATA;
//   vif.PREADY  <= req.PREADY;
//   vif.PSLVERR <= req.PSLVERR; 
//         @(vif.drv_cb);
//       end
//       else begin
        

//   // Wait until slave ready
//   while (!vif.PREADY) @(posedge vif.PCLK);

//   // Latch read data and errors
//   req.PRDATA  <= vif.PRDATA;
//   req.PREADY  <= vif.PREADY;
//   req.PSLVERR <= vif.PSLVERR;

//   // Finish transfer
//   @(posedge vif.PCLK);
//   vif.PSEL    <= 0;
//   vif.PENABLE <= 0;
//   vif.PWRITE  <= 0;
//   vif.PADDR   <= '0;
//   vif.PWDATA  <= '0;
//   vif.PSTRB   <= '0;

//   $display("time[%0t] DRIVER: Transfer done: addr=%0h data=%0h write=%0d", 
//            $time, req.PADDR, req.PWDATA, req.write_read);
// endtask
   vif.drv_cb.transfer    <= req.transfer;
    vif.drv_cb.PRESETn    <= req.PRESETn;
    `uvm_info("DRIVER", $sformatf("[drv]sent transfer=%0d reset=%0d",req.transfer,req.PRESETn), UVM_LOW)

    if(req.PRESETn == 1)       
      begin
        if(req.transfer == 1)
        begin
          
          //repeat(1) @(vif.drv_cb);
          
          
          vif.drv_cb.strb_in     <= req.strb_in;
          vif.drv_cb.wdata_in    <= req.wdata_in;
          vif.drv_cb.write_read  <= req.write_read;
          vif.drv_cb.addr_in     <= req.addr_in;
          `uvm_info("DRIVER", $sformatf("[drv] sent strb=%0d | wdata=%0d | read_write = %0d | address =%0d",req.strb_in,req.wdata_in,req.write_read,req.addr_in), UVM_LOW)
          
          //repeat(2) @(vif.drv_cb);
      
          if(req.PREADY == 1)
            begin
              vif.drv_cb.PREADY  <= req.PREADY;
              vif.drv_cb.PSLVERR <= req.PSLVERR;
              vif.drv_cb.PRDATA  <= req.PRDATA;
              `uvm_info("DRIVER", $sformatf("[drv] PREADY is 1 No wait cycles --- sent  PREADY=%0d | PSLVERR = %0d | PRDATA =%0d",req.PREADY,req.PSLVERR,req.PRDATA), UVM_LOW)
            @(vif.drv_cb);
            end
          else
            begin
              while(req.PREADY!=1)     
                begin
                  $display("DRIVER INSIDE WAIT CYCLE");
                  @(vif.drv_cb);
                  req.randomize();
                end
              vif.drv_cb.PREADY  <= req.PREADY;
              vif.drv_cb.PSLVERR <= req.PSLVERR;
              vif.drv_cb.PRDATA  <= req.PRDATA;
              `uvm_info("DRIVER", $sformatf("[drv] Got PREADY as 1 --- sent  PREADY=%0d | PSLVERR = %0d | PADDR =%0d",req.PREADY,req.PSLVERR,req.PRDATA), UVM_LOW)
              @(vif.drv_cb);
            end           
        end
      end
//         else if(req.transfer == 1 && prev_transfer == 1)
//           begin
//             prev_transfer = req.transfer;

//             vif.strb_in     <= req.strb_in;
//             vif.wdata_in    <= req.wdata_in;
//             vif.write_read  <= req.write_read;
//             vif.addr_in     <= req.addr_in;

//             repeat(1) @(posedge vif.drv_cb);
          
//             if(req.PREADY == 1)
//               begin
//                 vif.PREADY  <= req.PREADY;
//                 vif.PSLVERR <= req.PSLVERR;
//                 vif.PRDATA  <= req.PRDATA;
//               end
//             else
//               begin
//                 while(req.PREADY == 0)   // FIX — reference req
//                   begin
//                     @(vif.drv_cb);
//                     req.randomize();
//                     vif.PREADY <= req.PREADY;
//                   end
//                 vif.PSLVERR <= req.PSLVERR;
//                 vif.PRDATA  <= req.PRDATA;
//               end     
//            end
//         else
//           prev_transfer = req.transfer;
//       end
    
     @(vif.drv_cb);
    
  endtask
  
endclass



