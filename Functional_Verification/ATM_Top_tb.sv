module ATM_Top_tb #(parameter   password_width = 4,
                                balance_width = 20, 
							    card_width = 3,
                                users_num = 7);
    reg clk, rst, language, another_service, card_out_reg;	
    reg [card_width-1:0] card_number;
    reg [password_width-1:0] password_input;
    reg [1:0] operation;
    reg [balance_width-1:0] value;
	reg [31:0] threshold;
    wire card_out, op_done, error, wrong_psw;
    wire [balance_width-1:0] updated_balance;
    integer i;

    reg [balance_width-1:0] balance_reg  [0:users_num-1];
    reg [password_width-1:0] password_reg [0:users_num-1];

    ATM_Top top
    (
        clk, rst, card_number, password_input, card_out, language, operation, value, another_service, updated_balance, op_done, error, wrong_psw
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        $readmemb("./Database/password_memory.txt", password_reg);
        rst = 0;
        @(negedge clk);
        for (i = 0; i < 1000; i=i+1) begin
            $readmemb("./Database/balance_memory.txt" , balance_reg);
            rst = $random();
            card_number = $random();
            card_out_reg = $random();
            password_input = $random();
            language = $random();
            operation = $random();
            value = $random();
            another_service = $random();
            repeat (10) @(negedge clk);
        end
        rst = 0;
        @(negedge clk);
        rst = 1;
        operation = 2'b11;
        repeat (10) @(negedge clk);
        if (card_out)
            $display("Timeout Check: Success");
        else
            $display("Timeout Check: Fail");
        
        rst = 0;
        @(negedge clk);
        $readmemb("./Database/balance_memory.txt" , balance_reg);
        rst = 1;
        card_number = 0;
        card_out_reg = 1;
        password_input = 4'b0011;
        operation = 2'b00;
        value = 20'd100;
        another_service = 0;
        $display("updated_balance: %d, prev_balance: %d, card_out: %d, op_done: %d, wrong_psw: %d, error: %d", updated_balance, balance_reg[card_number], card_out, op_done, wrong_psw, error);
        repeat (10) @(negedge clk);
        if (updated_balance == balance_reg[card_number] - value && card_out && op_done && !error && !wrong_psw)
            $display("withdraw Check: Success");
        else
            $display("withdraw Check: Fail, updated_balance: %d, prev_balance: %d, card_out: %d, op_done: %d, wrong_psw: %d, error: %d", updated_balance, balance_reg[card_number], card_out, op_done, wrong_psw, error);

        $stop();
    end
    assign card_out = card_out_reg ? 1 : 0;

    // psl rst_assertion: assert always( (!rst) -> next (!updated_balance && !op_done && !error && !wrong_psw) ) @(posedge clk);
    
    // psl wrong_psw_assertion: assert always( (password_input != password_reg[card_number] && !card_out) -> next (wrong_psw) abort !rst) @(posedge clk);

    // psl withdraw_assertion: assert always ( {(password_input == password_reg[card_number] && !card_out && operation == 2'b00 && value < balance_reg[card_number] && !another_service)[*10]} (updated_balance == balance_reg[card_number] - value && card_out && op_done && !error && !wrong_psw) abort !rst) @(posedge clk);

    // psl deposit_assertion: assert always ( {(password_input == password_reg[card_number] && !card_out && operation == 2'b01 && !another_service)[*10]} (updated_balance == balance_reg[card_number] + value && card_out && op_done && !error && !wrong_psw) abort !rst) @(posedge clk);

    // psl timeout_assertion: assert always ( {(operation == 2'b11)[*10]} (card_out) abort !rst) @(posedge clk);
    
    // psl inquiry_assertion: assert always( (password_input == password_reg[card_number] && !card_out && operation == 2'b10 && !another_service) -> next[5] (updated_balance == balance_reg[card_number] && op_done && !error && !wrong_psw) abort !rst) @(posedge clk);

    // psl assert always (never (card_number < users_num));
    // psl assert always( never (value < 20'd0) );
endmodule