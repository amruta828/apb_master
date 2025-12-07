`include "uvm_macros.svh"
`include "apb_interface.sv"
`include "apb_pkg.sv"
`include "design.sv"

module top();
 import uvm_pkg::*;
 import apb_pkg::*;

 bit PCLK=0;


 always#5 PCLK=~PCLK;
  
  initial begin
    vif.PRESETn = 0;
    #20;
    vif.PRESETn = 1;
end




  apb_interface vif(PCLK);
  
 apb_master dut(
   .PCLK(PCLK),
   .PRESETn(vif.PRESETn),
   .PADDR(vif.PADDR),
   .PSEL(vif.PSEL),
   .PENABLE(vif.PENABLE),
   .PWRITE(vif.PWRITE),
   .PWDATA(vif.PWDATA),
   .PSTRB(vif.PSTRB),
   .PRDATA(vif.PRDATA),
   .PREADY(vif.PREADY),
   .PSLVERR(vif.PSLVERR),
   .transfer(vif.transfer),
   .write_read(vif.write_read),
   .addr_in(vif.addr_in),
   .wdata_in(vif.wdata_in),
   .strb_in(vif.strb_in),
   .rdata_out(vif.rdata_out),
   .transfer_done(vif.transfer_done),
   .error(vif.error)
);

initial begin
  uvm_config_db#(virtual apb_interface)::set(uvm_root::get(),"*","vif",vif);
  
end

  initial begin
    run_test("apb_test");
    #1000 $finish;
  end
  
endmodule
