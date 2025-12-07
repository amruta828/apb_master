class apb_seq_item extends uvm_sequence_item;

  rand bit write_read;
  rand bit transfer;
  rand bit [7:0] addr_in;
  rand bit [31:0] wdata_in;
  rand bit [3:0] strb_in;
  rand bit PRESETn;
  rand bit PREADY;
  rand bit [31:0] PRDATA;
  rand bit PSLVERR;
 

  logic PSEL;
  logic PENABLE;
  logic [7:0]  PADDR;   
  logic [31:0] PWDATA;
  logic PWRITE;
  logic [31:0] rdata_out;
  logic [3:0]  PSTRB;
  logic transfer_done;
  logic error;

  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(PRESETn,UVM_ALL_ON)
    `uvm_field_int(PSEL,          UVM_ALL_ON)
    `uvm_field_int(PENABLE,       UVM_ALL_ON)
    `uvm_field_int(PWRITE,        UVM_ALL_ON)
    `uvm_field_int(PADDR,         UVM_ALL_ON)
    `uvm_field_int(PWDATA,        UVM_ALL_ON)
    `uvm_field_int(PRDATA,        UVM_ALL_ON)
    `uvm_field_int(PREADY,        UVM_ALL_ON)
    `uvm_field_int(PSLVERR,       UVM_ALL_ON)
    `uvm_field_int(transfer,      UVM_ALL_ON)
    `uvm_field_int(write_read,    UVM_ALL_ON)
    `uvm_field_int(addr_in,       UVM_ALL_ON)
    `uvm_field_int(wdata_in,      UVM_ALL_ON)
    `uvm_field_int(strb_in,       UVM_ALL_ON)
    `uvm_field_int(rdata_out,     UVM_ALL_ON)
    `uvm_field_int(transfer_done, UVM_ALL_ON)
    `uvm_field_int(error,         UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

endclass
