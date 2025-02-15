class tx_seq_item extends uvm_sequence_item;
	`uvm_object_utils(tx_seq_item)
	
	bit tx_tlast_o;
	bit tx_tvalid_o;
	bit [15:0] tx_tdata_o;
	
	rand bit tx_tready_i;
	
	
	function new (string name = "tx_seq_item");
		super.new(name);
	endfunction
	
	function string convert2str();
	   return $sformatf ("tx_tready_i =%0d",tx_tready_i);
	endfunction
	
	
endclass