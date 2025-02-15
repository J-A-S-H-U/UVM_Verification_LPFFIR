class rx_sequencer extends uvm_sequencer#(rx_seq_item);
	`uvm_component_utils(rx_sequencer) // registering the class to factory
	
	//creating a new constructor for sequencer class
	function new (string name ="rx_sequencer",uvm_component parent);
		super.new(name,parent);
		`uvm_info("rx_sequencer", "Inside Constructor!",UVM_LOW)
	endfunction 
	
	//Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("rx_sequencer", "Build Phase!",UVM_LOW)
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("rx_sequencer", "Connect Phase!",UVM_LOW)
	endfunction

endclass