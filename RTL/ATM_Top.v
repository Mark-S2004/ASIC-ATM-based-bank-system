`include "ATM_FSM.v"
`include "cardhandling.v"
`include "timer.v"

module ATM_Top #(parameter  password_width = 16,
                            balance_width = 20, 
							card_width = 6)
							
( 
    input wire clk,
    input wire rst,
	//cardhandling inputs
	input wire [card_width-1:0] card_number,
	input wire card_in,    
    input wire [password_width-1:0] password_input,
	//ATM_FSM inputs 
    input wire language,
    input wire [1:0] operation,
    input wire [balance_width-1:0] value,
    input wire another_service,	
	//timer input 
	input wire [31:0] threshold,
	//output from ATM_FSM
	output wire	card_out,
	output wire [balance_width-1:0] updated_balance, //output from ATM_FSM and also transmitted to card_handling to update user data
	output wire op_done, 
	output wire error,
	output wire wrong_psw
	
	);

//wire  [balance_width-1:0] updated_balance; //output from ATM_FSM to card_handling
wire  [balance_width-1:0] balance;//from card_handling to ATM_FSM
wire  psw_en;//from card_handling to ATM_FSM

//timer inputs 
wire timeout ; //flag to ATM_FSM that time out the card will be executed (go to idle)

//ATM_FSM
wire start_timer ; // to adjust timer (start running time)
wire restart_timer; //to reset timer between states 

card_handling U0_card_handling (
    .clk(clk),
    .rst(rst),
    .card_number(card_number),
    .card_in(card_in),
	.card_out(card_out),
    .op_done(op_done),
	.updated_balance(updated_balance),
    .password_input(password_input),

    .balance(balance),
    .psw_en(psw_en),
    .wrong_psw(wrong_psw)
);

timer U0_timer (
    .clk(clk),
    .rst(rst),
    .start(start_timer),
	.restart(restart_timer),
    .timeout(timeout)
);

ATM_FSM U0_ATM_FSM (
    .clk(clk),
    .rst(rst),
    .timeout(timeout),
    .wrong_psw(wrong_psw),
    .current_balance(balance),
    .language(language),
    .operation(operation),
    .value(value),
    .another_service(another_service),
    .psw_en(psw_en),

    .balance(updated_balance),
	.card_out(card_out),
	.op_done(op_done),
    .error(error),
    .start_timer(start_timer),
    .restart_timer(restart_timer)
);

endmodule