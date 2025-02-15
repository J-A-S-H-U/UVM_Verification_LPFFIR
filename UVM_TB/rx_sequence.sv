class rx_sequence extends uvm_sequence#(rx_seq_item);
	`uvm_object_utils(rx_sequence)

	rx_seq_item rx_item;

	function new (string name = "rx_sequence");
		super.new(name);
	endfunction

    int num = 2048;
	
	task body();
	for (int i =0; i<num; i++) begin
		`uvm_info("rx_sequence", "INSIDE RX SEQUENCE BODY", UVM_LOW)
		rx_item = rx_seq_item::type_id::create("rx_item");
		start_item(rx_item);
		assert(rx_item.randomize() with {rx_tlast_i == '1; rx_tvalid_i == '1;});
		`uvm_info("rx_sequence",$sformatf("Generate new item: %s",rx_item.convert2str()),UVM_LOW)
			$display("------------------------------------------------------------------");
			$display("------------------------------------------------------------------");
			finish_item(rx_item);
			`uvm_info("rx_sequence",$sformatf(" Done Generate new RX item: %d",i),UVM_LOW)
	    end
		 `uvm_info("rx_sequence",$sformatf(" Done Generation of RX items: %d",num),UVM_LOW)
	endtask
	
endclass