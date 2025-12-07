interface apb_interface(input logic PCLK);
  bit PRESETn;
  bit transfer;
  bit write_read;
  bit [7:0]addr_in;
  bit [31:0]wdata_in;
  bit [3:0]strb_in;
  bit PREADY;
  bit PSLVERR;
  bit [31:0]PRDATA;
  logic PSEL;
  logic [0:31]rdata_out;
  logic transfer_done;
  logic error;
  logic PENABLE;
  logic PWRITE;
  logic [3:0]PSTRB; 
  logic [31:0]PWDATA;
  logic [7:0]PADDR;
   
  clocking drv_cb @(posedge PCLK);
    default input #0 output #0;
    output  transfer,write_read,addr_in,wdata_in,PREADY,PRDATA,PSLVERR,strb_in,PRESETn;
     
  endclocking
  
  clocking mon_cb @(posedge PCLK);
    default input #0 output  #0;
    input PREADY,PRDATA,PSLVERR,PENABLE,PSEL,PWRITE,PADDR,PWDATA,PSTRB,PRESETn,rdata_out,transfer_done,error,transfer,write_read,addr_in,wdata_in,strb_in;
    
  endclocking
  
  modport DRV(clocking drv_cb);
    modport MON(clocking mon_cb);
endinterface
  
