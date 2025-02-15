class coverage extends uvm_test ;
`uvm_component_utils(coverage)// regisering the covergae class with the factory
uvm_analysis_imp #(rx_seq_item, coverage) coverage_port;// craeting annalysis port for the coverage

real coverage_score1;
real coverage_score2;
real coverage_score3;
real total_coverage;
rx_seq_item cov_pkt;
//virtual intfc cov_if; // virtaul interface handle



//creating cover groups for write and read address
covergroup cov_in with function sample(rx_seq_item cov_pkt) ;
    a1: coverpoint cov_pkt.rx_tdata_i { // Measure coverage
       bins tdata1[512]= {[16'h0000:16'hFFFF]};
    }
   endgroup


// creating a new constructor for coverage class and all the above created cover groups
function new (string name="coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("COVERAGE CLASS", "Inside Constructor!", UVM_LOW)
cov_in=new();
endfunction

//Buid Phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("COVERAGE CLASS", "Build Phase!", UVM_HIGH)
   
    coverage_port = new("coverage_port", this); 
endfunction
  
  // Write Function
function void write(rx_seq_item t);
cov_in.sample(t);
endfunction

// Extract Phase
function void extract_phase(uvm_phase phase);
   super.extract_phase(phase);
  coverage_score1=cov_in.get_coverage();
endfunction

//Report Phase
function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("COVERAGE CLASS",$sformatf("Coverage=%0f%%",coverage_score1),UVM_LOW);
endfunction

endclass