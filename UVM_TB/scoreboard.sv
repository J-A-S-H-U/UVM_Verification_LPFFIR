`uvm_analysis_imp_decl(_rx_reference_port)
`uvm_analysis_imp_decl(_mon_result_port)


class scoreboard extends uvm_component;
	`uvm_component_utils(scoreboard)// registering the calss with the factory
	 
	uvm_analysis_imp_rx_reference_port #(rx_seq_item,scoreboard) rx_reference_import; // creating annalysis port for scoreboard
	uvm_analysis_imp_mon_result_port#(tx_seq_item,scoreboard) mon_result_import;
	 //creating a new constructor for scoreboard class
	 
	rx_seq_item reference_queue[$];
	tx_seq_item output_queue[$];
	
	rx_seq_item curr_reference;
	tx_seq_item curr_output;
	 
	 
	function new(string name= "scoreboard",uvm_component parent);
		super.new(name,parent);
		`uvm_info("SCOREBOARD", "Inside Constructor!",UVM_LOW)
	endfunction
	
	//Build Phase
	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
		`uvm_info("SCOREBOARD", "Build phase!",UVM_LOW)
		
		rx_reference_import = new("rx_reference_import",this);// creating new constructor for scoreboard analysis port
		mon_result_import = new("mon_result_import",this);
		
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
			wait(reference_queue.size != 0 && output_queue.size != 0);
			curr_reference = reference_queue.pop_back();
			curr_output = output_queue.pop_back();
			
			compare(curr_reference,curr_output);		
	 
		end
	endtask
	 
	 
	//write function for reference fifo queue
	extern function void write_rx_reference_port(rx_seq_item rxitem);
	
	
	extern function void write_mon_result_port(tx_seq_item txitem);
	
	
	function void compare(rx_seq_item read_reference, tx_seq_item read_output);
	
	if (read_reference.ref_tdata_i === read_output.tx_tdata_o)
	begin
	//$display("Stored data values: %0d %0d %0d %0d %0d %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]);
		$display("| DATA PASSED	| Output: %0d | ref_value = %0d	", read_output.tx_tdata_o, read_reference.ref_tdata_i);
	end
	else 
	begin
    //$display("Stored data values: %0d %0d %0d %0d %0d %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]);
		$display("| DATA FAILED	| Output: %0d | ref_value = %0d	", read_output.tx_tdata_o, read_reference.ref_tdata_i);
	end
	
	endfunction	
		
endclass



function void scoreboard::write_rx_reference_port(rx_seq_item rxitem);
	 reference_queue.push_front(rxitem);
		`uvm_info("Scoreboard write reference",$sformatf("REF MODEL DATA",rxitem.ref_tdata_i),UVM_LOW) 
	endfunction
	
function void scoreboard::write_mon_result_port(tx_seq_item txitem);
	 output_queue.push_front(txitem);
		`uvm_info("Scoreboard write output",$sformatf("DUT DATA",txitem.tx_tdata_o),UVM_LOW) 
	endfunction