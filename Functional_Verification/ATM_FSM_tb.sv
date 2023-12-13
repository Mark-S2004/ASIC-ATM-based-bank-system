module ATM_FSM_tb #(parameter balance_width = 20);
    reg clk, rst, timeout, wrong_psw, language, another_service;
    reg [balance_width-1:0] current_balance;
    reg [1:0] operation;  // withdraw(2'b00), deposit(2'b01), balance(2'b10)
    reg [balance_width-1:0] value;

    wire card_in;

    wire [balance_width-1:0] balance;
    wire op_done, error, start_timer;
    reg restart_timer;

    integer i;

    reg card_in_reg;

    ATM_FSM # (.balance_width(balance_width)) FSM (
    .clk(clk),
    .rst(rst),
    .timeout(timeout),
    .wrong_psw(wrong_psw),
    .current_balance(current_balance),
    .language(language),  // Arabic(1'b1), English(1'b0)
    .operation(operation),  // withdraw(2'b00), deposit(2'b01), balance(2'b10)
    .value(value),
    .another_service(another_service),
    .card_in(card_in),
    .balance(balance),
    .op_done(op_done),
    .error(error), 
    .start_timer(start_timer), 
    .restart_timer(restart_timer)
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        rst = 0;
        @(negedge clk);
        for (i = 0; i < 1000; i = i + 1) begin
            rst = $random();
            timeout = $random();
            wrong_psw = $random();
            language = $random();
            another_service = $random();
            current_balance = $random();
            operation = $random();
            value = $random();
            card_in_reg = $random();
            @(negedge clk);
        end
        $stop();
    end
    assign card_in = card_in_reg;

    // psl rst_assertion: assert always( (!rst) -> next (!balance && !op_done && !error && !start_timer) ) @(posedge clk);
    // psl withdraw_assertion: assert always( (!wrong_psw && operation == 2'b00 && !another_service) -> next (balance == current_balance - value && op_done && !error) abort !rst) @(posedge clk);
    // psl deposit_assertion: assert always( (!wrong_psw && operation == 2'b01 && !another_service) -> next (balance == current_balance + value && op_done && !error) abort !rst) @(posedge clk);
    // psl inquiry_assertion: assert always( (!wrong_psw && operation == 2'b10 && !another_service) -> next (balance == current_balance && op_done && !error) abort !rst) @(posedge clk);
endmodule