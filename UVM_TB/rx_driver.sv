class rx_driver extends uvm_driver #(rx_seq_item);
	`uvm_component_utils(rx_driver)
	
	virtual rx_intf vif_rx;	// virtaul interface handle
	rx_seq_item drv_pkt_rx; //class handle for sequence item class
	
	
	//creating a new constructor for driver class
	function new(string name ="rx_driver",uvm_component parent);
		super.new (name,parent);
		`uvm_info("rx_driver", "Inside Constructor!",UVM_LOW)
	endfunction
	

	//Build Phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("rx_driver", "Build Phase!",UVM_LOW)
		
		if(!(uvm_config_db #(virtual rx_intf)::get(this,"*","vif",vif_rx))) // checking proper connection of interface
		begin
			`uvm_error("rx_driver", "Failed to get vif from config DB!")
		end
		
	endfunction
	
	
	//Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("rx_driver", "Connect Phase!",UVM_LOW)
		
	endfunction	
		
			
	//Run Phase	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("rx_driver", "Inside run Phase!",UVM_LOW)
		forever 
		 begin
			drv_pkt_rx = rx_seq_item::type_id::create("drv_pkt_rx");
			seq_item_port.get_next_item(drv_pkt_rx);
			drive(drv_pkt_rx);
			seq_item_port.item_done();
		 end
    endtask
	
	//Drive Method
	task drive(rx_seq_item drv_pkt_rx);
	wait (vif_rx.aresetn_i);
	@(posedge vif_rx.aclk_i)
		vif_rx.rx_tlast_i <= drv_pkt_rx.rx_tlast_i;
		vif_rx.rx_tvalid_i <= drv_pkt_rx.rx_tvalid_i;
		vif_rx.rx_tdata_i <= drv_pkt_rx.rx_tdata_i;
		`uvm_info("rx_driver write data_dut",$sformatf("rx_tlast_i=%0d, rx_tvalid_i=%0d, rx_tdata_i=%0d",vif_rx.rx_tlast_i, vif_rx.rx_tvalid_i,vif_rx.rx_tdata_i),UVM_LOW)

	endtask
	
endclass
    		 
			 
		
	