vlib work
vlog -sv ./Functional_Verification/timer_tb.sv ./RTL/timer.v +cover
vsim -voptargs=+acc work.timer_tb -cover
add wave rst start restart timeout
coverage save ./Functional_Verification/Code_Coverage_Report/timer_tb_db.ucdb -onexit -du timer
run -all