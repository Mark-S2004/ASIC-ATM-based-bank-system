vlib work
vlog -sv ./Functional_Verification/cardHandling_tb.sv ./RTL/cardhandling.v +cover
vsim -voptargs=+acc work.cardHandling_tb -cover
add wave *
coverage save ./Functional_Verification/Code_Coverage_Report/cardHandling_tb_db.ucdb -onexit -du cardhandling
run -all