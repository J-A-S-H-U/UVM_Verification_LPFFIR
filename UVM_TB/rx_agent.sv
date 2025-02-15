class rx_agent extends uvm_agent;
	`uvm_component_utils(rx_agent) //registering the class with factory

	rx_sequencer  s0_rx;//class handle for sequencer class
	rx_driver d0_rx;//class handle for driver class
	rx_monitor mon_rx;// class handle for monitor class

//creating a new constructor for sequencer class
	function new(string name ="rx_agent",uvm_component parent);
		super.new(name,parent);
		`uvm_info("rx_agent", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//build phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("rx_agent", "BUILD PHASE!",UVM_LOW)
		s0_rx = rx_sequencer::type_id::create("s0_rx",this);
		d0_rx = rx_driver::type_id::create("d0_rx",this);
		mon_rx = rx_monitor:: type_id::create("mon_rx", this);
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("rx_agent", "CONNECT PHASE!",UVM_LOW)
		d0_rx.seq_item_port.connect(s0_rx.seq_item_export);
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("rx_agent", "INSIDE BUILD PHASE!",UVM_LOW)
	endtask
	
endclass