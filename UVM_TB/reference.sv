class reference extends uvm_component;
	`uvm_component_utils(reference)// registering the calss with the factory
	 
	uvm_analysis_imp #(rx_seq_item,reference) rx_reference_port; // creating annalysis port for scoreboard
	uvm_analysis_port#(rx_seq_item) ref_result_port;
	 //creating a new constructor for scoreboard class
	 
	rx_seq_item trans[$];
	
	
	
	
	logic [15:0]sdata[0:5];
	int init_flag = 1;
	int save_pnt = 5;
	
	
	function new(string name= "scoreboard",uvm_component parent);
		super.new(name,parent);
		`uvm_info("SCOREBOARD", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//Build Phase
	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
		`uvm_info("SCOREBOARD", "Build phase!",UVM_LOW)
		
		rx_reference_port = new("rx_reference_port",this);// creating new constructor for scoreboard analysis port
		ref_result_port = new("ref_result_port",this);
		

		
		endfunction
		
	//Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SCOREBOARD", "Connect Phase!",UVM_LOW)
	endfunction
	
	
	//Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("SCOREBOARD", "Run Phase!",UVM_LOW)
		forever
		begin
		rx_seq_item curr_rxitem;
		wait(trans.size != 0);
		curr_rxitem = trans.pop_back();
		`uvm_info("reference write RUN PHASE",$sformatf("rx_tlast_i=%d, rx_tvalid_i=%d, rx_tdata_i=%0d, rx_tready_o=%0d",curr_rxitem.rx_tlast_i, curr_rxitem.rx_tvalid_i, curr_rxitem.rx_tdata_i, curr_rxitem.rx_tready_o),UVM_LOW) 
		calc(curr_rxitem);
	 
	 end
	endtask
	 
	 
	//write function for reference fifo queue
	function void write(rx_seq_item rxitem);
	 trans.push_front(rxitem);
		`uvm_info("reference write data_in",$sformatf("rx_tlast_i=%d, rx_tvalid_i=%d, rx_tdata_i=%0d, rx_tready_o=%0d",rxitem.rx_tlast_i, rxitem.rx_tvalid_i, rxitem.rx_tdata_i, rxitem.rx_tready_o),UVM_LOW) 
	endfunction
	
	
	function void calc(rx_seq_item read_trans);
	rx_seq_item result;
	
	result = rx_seq_item::type_id::create("result");
	
	  
	
	//logic [15:0]ref_value;
  	
	if (init_flag == 1)
	begin
		init_flag = 0;
		foreach (sdata[j])
			sdata[j] = 0;
	end
	
	if (result == null) begin
    `uvm_fatal("CALC", "Result object is null! Ensure proper creation.")
	end
	
	else if (save_pnt > 5)
	begin 
		save_pnt = 0;
		`uvm_info("reference QUEUE UP DATA",$sformatf("rx_tdata_i: %0d", read_trans.rx_tdata_i), UVM_LOW)
		sdata[save_pnt] = read_trans.rx_tdata_i;
		`uvm_info("reference QUEUE UP",$sformatf("sdata[%0d]: %0d", save_pnt, sdata[save_pnt]), UVM_LOW)
		save_pnt++;
		result.ref_tdata_i = sdata[0] + sdata[3] + sdata[1] + sdata[2] + sdata[4] + sdata[5];
		`uvm_info("reference QUEUE UP",$sformatf("sdata[0]: %0d, sdata[1]: %0d, sdata[2]: %0d, sdata[3]: %0d, sdata[4]: %0d, sdata[5]: %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]), UVM_LOW)
		`uvm_info("reference QUEUE UP SUM",$sformatf("result: %0d", result.ref_tdata_i), UVM_LOW)

	end
	else
	begin
		`uvm_info("reference QUEUE BOTTOM DATA",$sformatf("rx_tdata_i: %0d", read_trans.rx_tdata_i), UVM_LOW)
		sdata[save_pnt] = read_trans.rx_tdata_i;
		`uvm_info("reference QUEUE BOTTOM",$sformatf("sdata[%0d]: %0d", save_pnt, sdata[save_pnt]), UVM_LOW)
		save_pnt++;
		result.ref_tdata_i = sdata[0] + sdata[3] + sdata[1] + sdata[2] + sdata[4] + sdata[5];
		`uvm_info("reference QUEUE BOTTOM",$sformatf("sdata[0]: %0d, sdata[1]: %0d, sdata[2]: %0d, sdata[3]: %0d, sdata[4]: %0d, sdata[5]: %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]), UVM_LOW)
		`uvm_info("reference QUEUE BOTTOM SUM",$sformatf("result: %0d", result.ref_tdata_i), UVM_LOW)

	end
	
	ref_result_port.write(result);
	`uvm_info("reference write port input",$sformatf("rx_tdata_i=%0d", result.ref_tdata_i),UVM_LOW) 

	
	endfunction	
	
	
	
	
	
	
		
endclass