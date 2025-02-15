module uvmtb_top;

`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"



`include "rx_intf.sv"
`include "tx_intf.sv"

`include "rx_seq_item.sv"
`include "tx_seq_item.sv"

`include "rx_sequence.sv"
`include "tx_sequence.sv"

`include "rx_sequencer.sv"
`include "tx_sequencer.sv"

`include "rx_driver.sv"
`include "tx_driver.sv"

`include "rx_monitor.sv"
`include "tx_monitor.sv"

`include "rx_agent.sv"
`include "tx_agent.sv"

`include "coverage.sv"
`include "reference.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"



	bit aclk_i;
	bit aresetn_i;
	
	
	// Instantiating the Top level DUT and interface
	rx_intf rx_inf ();
	tx_intf tx_inf ();
	lpffir_axis DUT (.rx_tlast_i(rx_inf.rx_tlast_i), .rx_tvalid_i(rx_inf.rx_tvalid_i), .rx_tdata_i(rx_inf.rx_tdata_i), .rx_tready_o(rx_inf.rx_tready_o), .tx_tlast_o(tx_inf.tx_tlast_o), .tx_tvalid_o(tx_inf.tx_tvalid_o), .tx_tdata_o(tx_inf.tx_tdata_o), .tx_tready_i(tx_inf.tx_tready_i), .aclk_i(aclk_i), .aresetn_i(aresetn_i));
	
	
	assign rx_inf.aclk_i = aclk_i;
	assign rx_inf.aresetn_i = aresetn_i;
	
	assign tx_inf.aclk_i = aclk_i;
	assign tx_inf.aresetn_i = aresetn_i;
	
	// connecting interface through uvm_config_db to other test bench components
	initial begin
		uvm_config_db #(virtual rx_intf ):: set(null, "*", "vif", rx_inf);
		uvm_config_db #(virtual tx_intf ):: set(null, "*", "vif", tx_inf);
	end
	
	
	initial begin
		run_test("uvmtest");
	end
	
	// clock generation
	always #5 aclk_i = ~aclk_i;
	
	
	//reset Generation
    initial begin
	    aresetn_i = 0;
		
		#15 aresetn_i = 1;
    end
	
	
	initial begin
		#100000;
		$display("sorry ran out of clock cycles");
		$finish;
	end
	
	
endmodule