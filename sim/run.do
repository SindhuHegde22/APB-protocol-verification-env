vdel -all
vlib work
vmap work work

vlog -cover bcst top11.sv

vsim top11 -voptargs=+acc

add wave -group APB_BUS top11/vif/PCLK
add wave -group APB_BUS top11/vif/PRESETn
add wave -group APB_BUS top11/vif/PSEL
add wave -group APB_BUS top11/vif/PENABLE
add wave -group APB_BUS top11/vif/PWRITE
add wave -group APB_BUS top11/vif/PADDR
add wave -group APB_BUS top11/vif/PWDATA
add wave -group APB_BUS top11/vif/PRDATA
add wave -group APB_BUS top11/vif/PREADY

add wave -group FSM top11/dut/state
add wave -group FSM top11/dut/next_state

add wave -group INTERNAL top11/dut/addr_reg
add wave -group INTERNAL top11/dut/wdata_reg
add wave -group INTERNAL top11/dut/wait_cnt

run 1000
wave zoom full
