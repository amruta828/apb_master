class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)
  apb_seq_item req;
  
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        req=apb_seq_item::type_id::create("req");
        wait_for_grant();
        req.randomize();
        send_request(req);
        wait_for_item_done();
      end
  endtask
  
endclass
  
    
