vlib work
vcom -work work ../vhdl/package_func.vhd
vcom -work work ../vhdl/package_proc.vhd
vcom -work work ../vhdl/alu.vhd
vcom -work work ../vhdl/RAM.vhd
vcom -work work ../vhdl/mux.vhd
vcom -work work ../vhdl/decoder2.vhd
vcom -work work ../vhdl/top.vhd
vcom -work work ../vhdl/tb.vhd


vsim work.testbench


add wave reset
add wave clk_tb
add wave instr
add wave pin_A
add wave pin_B
add wave pc_o
add wave res
add wave st
add wave cur_state


run -all
run 1000ns
wave zoom full
