vlib work
vlog -sv ./Functional_Verification/ATM_FSM_tb.sv ./RTL/ATM_FSM.v +cover
vsim -voptargs=+acc work.ATM_FSM_tb -cover
add wave *
coverage save ./Functional_Verification/Code_Coverage_Report/ATM_FSM_tb_db.ucdb -onexit -du ATM_FSM
run -all