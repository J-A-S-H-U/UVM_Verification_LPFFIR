module lpffir_axis (
                    input               aclk_i,
                    input               aresetn_i,
                    // AXI-Stream RX interface
                    input               rx_tlast_i,
                    input               rx_tvalid_i,
                    output logic        rx_tready_o,
                    input [15:0]        rx_tdata_i,
                    // AXI-Stream TX interface
                    output logic        tx_tlast_o,
                    output reg          tx_tvalid_o,
                    input               tx_tready_i,
                    output logic [15:0] tx_tdata_o);

   wire lpffir_en;
   reg misc;
   assign                                lpffir_en = rx_tvalid_i && tx_tready_i;

   // AXI-Stream interface
   assign rx_tready_o = lpffir_en;
   assign tx_tvalid_o = lpffir_en;
   assign tx_tlast_o  = rx_tlast_i;
  
  // DEBUG
  always @(posedge aclk_i or negedge aresetn_i)
    if (!aresetn_i) 
	  misc <= '0;

   // LPFFIR
   lpffir_core core(
                           .clk_i(aclk_i),
                           .rstn_i(aresetn_i),
                           .en_i(lpffir_en),
                           .x_i(rx_tdata_i),
                           .y_o(tx_tdata_o));

endmodule