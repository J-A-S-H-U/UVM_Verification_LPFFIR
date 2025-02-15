class tx_sequence extends uvm_sequence#(tx_seq_item);
	`uvm_object_utils(tx_sequence)

	tx_seq_item tx_item;

	function new (string name = "tx_sequence");
		super.new(name);
	endfunction

	int num = 2048;
	task body();
	for (int i =0; i<num; i++) begin
		`uvm_info("tx_sequence", "INSIDE TX SEQUENCE BODY", UVM_LOW)
		tx_item = tx_seq_item::type_id::create("tx_item");
		start_item(tx_item);
		assert(tx_item.randomize() with {tx_tready_i == '1;});
		`uvm_info("tx_sequence",$sformatf("Generate new item: %s",tx_item.convert2str()),UVM_LOW)
			$display("------------------------------------------------------------------");
			$display("------------------------------------------------------------------");
			finish_item(tx_item);
			`uvm_info("tx_sequence",$sformatf(" Done Generate new TX item: %d",i),UVM_LOW)
	    end
		 `uvm_info("tx_sequence",$sformatf(" Done Generation of TX items: %d",num),UVM_LOW)
	endtask
	
endclass