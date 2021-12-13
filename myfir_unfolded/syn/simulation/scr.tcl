vlib work
vcom -reportprogress 300 -work work ./constants.vhd
vlog -reportprogress 300 -work work ./myfir.v
vcom -reportprogress 300 -work work ./testbench/clk_gen.vhd
vcom -reportprogress 300 -work work ./testbench/data_maker_new.vhd
vcom -reportprogress 300 -work work ./testbench/data_sink.vhd
vlog -reportprogress 300 -work work ./testbench/tb_fir.v

vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_fir

vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=./myfir.sdf work.tb_fir

vcd file ./vcd/myfir_syn.vcd
vcd add /tb_fir/UUT/*

run 1800 ns
