vlib work
vlog -sv ./Functional_Verification/ATM_Top_tb.sv ./RTL/ATM_Top.v +cover
vsim -voptargs=+acc work.ATM_Top_tb -cover
add wave *
coverage save ./Functional_Verification/Code_Coverage_Report/ATM_Top_tb_db.ucdb -onexit -du ATM_Top
run -all