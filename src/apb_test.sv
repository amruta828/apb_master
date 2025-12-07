
class apb_test extends uvm_test;

  `uvm_component_utils(apb_test)

	apb_environment env;
	apb_sequence seq1;


  function new(string name="apb_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  env = apb_environment::type_id::create("env", this);
      seq1 = apb_sequence::type_id::create("seq1");
	endfunction 

	function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction


	task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq1.start(env.a_agent.seqr);
      phase.drop_objection(this);


	endtask
endclass

