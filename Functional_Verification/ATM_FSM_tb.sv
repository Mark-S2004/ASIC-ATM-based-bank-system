module ATM_FSM_tb #(parameter balance_width = 20);
    reg clk, rst, timeout, wrong_psw, language, another_service;
    reg [balance_width-1:0] current_balance;
    reg [1:0] operation;  // withdraw(2'b00), deposit(2'b01), balance(2'b10)
    reg [balance_width-1:0] value;

    wire card_out;
    wire [balance_width-1:0] balance;
    wire op_done, error, start_timer;
    reg restart_timer;

    integer i;

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
    .balance(balance),
    .card_out(card_out),
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
            repeat (10) @(negedge clk);
        end
/*
        rst = 0;
        @(negedge clk);
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b01;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b01;
        value = 200;
        another_service = 0;
        current_balance = 20'd1200;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1400 )
            $display("Done");
        else
            $display("Fail");
          // DW
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b01;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b00;
        value = 200;
        another_service = 0;
        current_balance = 20'd1200;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1000 )
            $display("Done");
        else
            $display("Fail");
        // DI
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b01;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b10;
        value = 200;
        another_service = 0;
        current_balance = 20'd1200;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1200 )
            $display("Done");
        else
            $display("Fail");
        
        // WW
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b00;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b00;
        value = 200;
        another_service = 0;
        current_balance = 20'd800;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd600 ) 
            $display("Done");
        else
            $display("Fail");
        // WD
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b00;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b01;
        value = 200;
        another_service = 0;
        current_balance = 20'd800;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1000 ) 
            $display("Done");
        else
            $display("Fail");
        
        // WI
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b00;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b10;
        value = 200;
        another_service = 0;
        current_balance = 20'd800;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd800 ) 
            $display("Done");
        else
            $display("Fail");
        
        // II
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b10;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b10;
        value = 200;
        another_service = 0;
        current_balance = 20'd1000;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1000)
            $display("Done");
        else
            $display("Fail");
        
        // IW
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b10;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b00;
        value = 200;
        another_service = 0;
        current_balance = 20'd1000;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd800 )
            $display("Done");
        else
            $display("Fail");
        
        // ID
        rst = 1;
        timeout = 0;
        wrong_psw = 0;
        language = 0;
        another_service = 1;
        current_balance = 20'd1000;
        operation = 2'b10;
        value = 20'd200;
        
        repeat (10) @(negedge clk);;

        operation = 2'b01;
        value = 200;
        current_balance = 20'd1000;
        repeat (10) @(negedge clk);
        if (op_done && balance == 20'd1200 ) 
            $display("Done");
        else
            $display("Fail op_done: %b, balance: %d", op_done, balance);
        another_service = 0;
*/
        $stop();
    end

    // psl rst_assertion: assert always( (!rst) -> next (!balance && !error && !op_done) ) @(posedge clk);

    // psl withdraw_assertion: assert always( {(!wrong_psw && operation == 2'b00 && !another_service && !timeout && value < current_balance)[*10]} (balance == current_balance - value && op_done && card_out && !error) abort !rst) @(posedge clk);

    // psl invalid_withdraw_assertion: assert always( {(!wrong_psw && operation == 2'b00 && !another_service && !timeout && value > current_balance)[*10]} (balance == current_balance && op_done && card_out && error) abort !rst) @(posedge clk);

    // psl deposit_assertion: assert always( {(!wrong_psw && operation == 2'b01 && !another_service && !timeout)[*10]} (balance == current_balance + value && op_done && card_out && !error) abort !rst) @(posedge clk);

    // psl inquiry_assertion: assert always( {(!wrong_psw && operation == 2'b10 && !another_service && !timeout)[*10]} (balance == current_balance && op_done && card_out && !error) abort !rst) @(posedge clk);

    // psl assert always( never (value < 20'd0) );
endmodule