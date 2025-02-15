class tx_driver extends uvm_driver #(tx_seq_item);
	`uvm_component_utils(tx_driver)
	
	virtual tx_intf vif_tx;	// virtaul interface handle
	tx_seq_item drv_pkt_tx; //class handle for sequence item class
	
	
	//creating a new constructor for driver class
	function new(string name ="tx_driver",uvm_component parent);
		super.new (name,parent);
		`uvm_info("tx_driver", "Inside Constructor!",UVM_LOW)
	endfunction
	

	//Build Phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("tx_driver", "Build Phase!",UVM_LOW)
		
		if(!(uvm_config_db #(virtual tx_intf)::get(this,"*","vif",vif_tx))) // checking proper connection of interface
		begin
			`uvm_error("tx_driver", "Failed to get vif from config DB!")
		end
		
	endfunction
	
	
	//Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("tx_driver", "Connect Phase!",UVM_LOW)
		
	endfunction	
		
			
	//Run Phase	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("tx_driver", "Inside run Phase!",UVM_LOW)
		forever 
		 begin
			drv_pkt_tx = tx_seq_item::type_id::create("drv_pkt_tx");
			seq_item_port.get_next_item(drv_pkt_tx);
			drive(drv_pkt_tx);
			seq_item_port.item_done();
		 end
    endtask
	
	//Drive Method
	task drive(tx_seq_item drv_pkt_tx);
	wait(vif_tx.aresetn_i);
	@(posedge vif_tx.aclk_i)
		vif_tx.tx_tready_i <= drv_pkt_tx.tx_tready_i;
		`uvm_info("tx_driver write data_dut",$sformatf("tx_tready_i=%0d",vif_tx.tx_tready_i),UVM_LOW)

	endtask
	
endclass