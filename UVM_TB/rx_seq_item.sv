class rx_seq_item extends uvm_sequence_item;
	`uvm_object_utils(rx_seq_item)
	
	rand bit rx_tlast_i;
	rand bit rx_tvalid_i;
	rand bit [15:0] rx_tdata_i;
	
	bit [15:0] ref_tdata_i;
	
	bit rx_tready_o;
	
	
	function new (string name = "rx_seq_item");
		super.new(name);
	endfunction
	
	function string convert2str();
	   return $sformatf ("rx_tlast_i =%0d, rx_tvalid_i =%0d, rx_tdata_i =%0d",rx_tlast_i,rx_tvalid_i,rx_tdata_i);
	endfunction
	
	
endclass