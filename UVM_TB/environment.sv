class env extends uvm_env;
	`uvm_component_utils(env)

	rx_agent agnt_rx;
	tx_agent agnt_tx;// class handle for agent class
	scoreboard scb; //class handle for scoreboard class
	reference refr;// class handle for reference class
	coverage covr;// class handle for coverage class
	
	
	
	// creating a new constructor for environment class
	function new(string name ="env" , uvm_component parent);
		super.new(name,parent);
		`uvm_info("ENVIRONMENT CLASS", "Inside Constructor!",UVM_LOW)
	endfunction

	//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Build Phase!",UVM_LOW)
		
		agnt_rx = rx_agent ::type_id::create("agnt_rx",this);
		agnt_tx = tx_agent ::type_id::create("agnt_tx",this);
		scb = scoreboard:: type_id::create("scb", this);
		refr=reference::type_id::create("refr",this);
		covr=coverage::type_id::create("covr",this);
	endfunction
	
	
    //Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Connect Phase!",UVM_LOW)
		
		agnt_rx.mon_rx.monitor_port_rx.connect(refr.rx_reference_port);//connecting monitor analysis port to scoreboard analysis port
		refr.ref_result_port.connect(scb.rx_reference_import);
		agnt_tx.mon_tx.monitor_port_tx.connect(scb.mon_result_import);//connecting monitor analysis port to coverage analysis port
		agnt_rx.mon_rx.monitor_port_rx.connect(covr.coverage_port);
	endfunction
	
	//Run Phase
	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("ENVIRONMENT CLASS", "Inside Run Phase!",UVM_LOW)
	endtask
endclass
		
	
	