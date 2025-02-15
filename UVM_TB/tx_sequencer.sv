class tx_sequencer extends uvm_sequencer #(tx_seq_item);
	`uvm_component_utils(tx_sequencer) // registering the class to factory
	
	//creating a new constructor for sequencer class
	function new (string name ="tx_sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("tx_sequencer", "Inside Constructor!",UVM_LOW)
	endfunction 
	
	//Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("tx_sequencer", "Build Phase!",UVM_LOW)
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("tx_sequencer", "Connect Phase!",UVM_LOW)
	endfunction

endclass