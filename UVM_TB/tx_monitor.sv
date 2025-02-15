class tx_monitor extends uvm_monitor;
`uvm_component_utils(tx_monitor)
virtual tx_intf vif_tx; //virtual interafce handle
tx_seq_item mon_pkt_tx;// sequence item handle

uvm_analysis_port #(tx_seq_item) monitor_port_tx; // creating annalysis port for monitor

// creating a new constructor for monitor class
function new (string name="tx_monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("tx_monitor", "Inside Constructor!",UVM_LOW)
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("tx_monitor", "Inside Build Phase!",UVM_LOW)
	monitor_port_tx = new("monitor_port_tx", this);//creating a new constructor for monitor annalysis port
	if(!(uvm_config_db # (virtual tx_intf):: get (this, "*", "vif", vif_tx))) //checking proper connection with interface
	begin
	`uvm_error ("tx_monitor", "Failed to get vif from config DB!")
	end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("tx_monitor", "Inside Connect Phase!",UVM_LOW)
endfunction

//Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("tx_monitor", "Inside Run Phase!",UVM_LOW)
	
	forever @(posedge vif_tx.aclk_i)
	begin
		mon_pkt_tx = tx_seq_item::type_id::create("mon_pkt_tx");
		wait (vif_tx.aresetn_i);
        //tranfering data when reset is high
		if (vif_tx.tx_tvalid_o && vif_tx.tx_tready_i)
		begin
		//	mon_pkt_tx.tx_tlast_o <= vif_tx.tx_tlast_o;
		//	mon_pkt_tx.tx_tvalid_o <= vif_tx.tx_tvalid_o;
			mon_pkt_tx.tx_tdata_o = vif_tx.tx_tdata_o;  
		//	mon_pkt_tx.tx_tready_i <= vif_tx.tx_tready_i;
			monitor_port_tx.write(mon_pkt_tx);
			
			`uvm_info("tx_monitor write data_in from VIF",$sformatf("tx_tlast_o =%0d, tx_tvalid_o =%0d, tx_tdata_o =%0d, tx_tready_i =%0d",vif_tx.tx_tlast_o,vif_tx.tx_tvalid_o,vif_tx.tx_tdata_o,vif_tx.tx_tready_i),UVM_LOW)
			`uvm_info("tx_monitor write data_in from MON_PKT",$sformatf("tx_tlast_o =%0d, tx_tvalid_o =%0d, tx_tdata_o =%0d, tx_tready_i =%0d",mon_pkt_tx.tx_tlast_o,mon_pkt_tx.tx_tvalid_o,mon_pkt_tx.tx_tdata_o,mon_pkt_tx.tx_tready_i),UVM_LOW)

		end
		 // calling the write method from the scoreboard
	end
endtask

endclass