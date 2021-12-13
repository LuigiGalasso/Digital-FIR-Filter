vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/constants.vhd
vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/reg.vhd
vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/myfir.vhd
vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/testbench/clk_gen.vhd
vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/testbench/data_maker_new.vhd
vcom -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/testbench/data_sink.vhd
vlog -reportprogress 300 -work work /home/isa07/LAB1/opt/vhdl/Simulation/testbench/tb_fir.v

vsim -novopt work.tb_fir
add wave sim:/tb_fir/UUT/*
run 2200 ns
