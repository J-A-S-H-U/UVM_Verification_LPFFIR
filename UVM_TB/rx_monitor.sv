class rx_monitor extends uvm_monitor;
`uvm_component_utils(rx_monitor)
virtual rx_intf vif_rx; //virtual interafce handle
rx_seq_item mon_pkt_rx;// sequence item handle

uvm_analysis_port #(rx_seq_item) monitor_port_rx; // creating annalysis port for monitor

// creating a new constructor for monitor class
function new (string name="rx_monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("rx_monitor", "Inside Constructor!",UVM_LOW)
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("rx_monitor", "Inside Build Phase!",UVM_LOW)
	monitor_port_rx = new("monitor_port_rx", this);//creating a new constructor for monitor annalysis port
	if(!(uvm_config_db # (virtual rx_intf):: get (this, "*", "vif", vif_rx))) //checking proper connection with interface
	begin
	`uvm_error ("rx_monitor", "Failed to get vif from config DB!")
	end
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("rx_monitor", "Inside Connect Phase!",UVM_LOW)
endfunction

//Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("rx_monitor", "Inside Run Phase!",UVM_LOW)
	
	forever @(posedge vif_rx.aclk_i)
	begin
		mon_pkt_rx = rx_seq_item::type_id::create("mon_pkt_rx");
		wait (vif_rx.aresetn_i);
        //tranfering data when reset is high
		if (vif_rx.rx_tvalid_i && vif_rx.rx_tready_o)
		begin
			//mon_pkt_rx.rx_tlast_i <= vif_rx.rx_tlast_i;
			//mon_pkt_rx.rx_tvalid_i <= vif_rx.rx_tvalid_i;
			mon_pkt_rx.rx_tdata_i = vif_rx.rx_tdata_i;  
			//mon_pkt_rx.rx_tready_o <= vif_rx.rx_tready_o;
			monitor_port_rx.write(mon_pkt_rx); // calling the write method from the scoreboard
			`uvm_info("rx_monitor write data_in from VIF",$sformatf("rx_tlast_i =%0d, rx_tvalid_i =%0d, rx_tdata_i =%0d, rx_tready_o =%0d",vif_rx.rx_tlast_i,vif_rx.rx_tvalid_i,vif_rx.rx_tdata_i,vif_rx.rx_tready_o),UVM_LOW)
			`uvm_info("rx_monitor write data_in from MON_PKT",$sformatf("rx_tlast_i =%0d, rx_tvalid_i =%0d, rx_tdata_i =%0d, rx_tready_o =%0d",mon_pkt_rx.rx_tlast_i, mon_pkt_rx.rx_tvalid_i,mon_pkt_rx.rx_tdata_i,mon_pkt_rx.rx_tready_o),UVM_LOW)

		end
		
	end
endtask

endclass