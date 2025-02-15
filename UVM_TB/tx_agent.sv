class tx_agent extends uvm_agent;
	`uvm_component_utils(tx_agent) //registering the class with factory

	tx_sequencer  s0_tx;//class handle for sequencer class
	tx_driver d0_tx;//class handle for driver class
	tx_monitor mon_tx;// class handle for monitor class

//creating a new constructor for sequencer class
	function new(string name ="tx_agent",uvm_component parent);
		super.new(name,parent);
		`uvm_info("tx_agent", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//build phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("tx_agent", "BUILD PHASE!",UVM_LOW)
		s0_tx = tx_sequencer::type_id::create("s0_tx",this);
		d0_tx = tx_driver::type_id::create("d0_tx",this);
		mon_tx = tx_monitor:: type_id::create("mon_tx", this);
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("tx_agent", "CONNECT PHASE!",UVM_LOW)
		d0_tx.seq_item_port.connect(s0_tx.seq_item_export);
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("tx_agent", "INSIDE BUILD PHASE!",UVM_LOW)
	endtask
	
endclass