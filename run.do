vlib work
vdel -all
vlib work

vlog -lint fa.sv
vlog -lint rca.sv
vlog -lint lpffir_core.sv
vlog -lint design.sv
vlog -lint uvmtb_top.sv

vsim work.uvmtb_top


run -all