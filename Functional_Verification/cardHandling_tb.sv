module cardHandling_tb #(parameter  card_width = 3,
                                    password_width = 4,
                                    balance_width = 20,
                                    users_num = 7);

    reg clk;
    reg rst;
    reg [card_width-1:0] card_number;
    reg op_done;
    reg [balance_width-1:0] updated_balance;
    reg [password_width-1:0] password_input;

    wire [balance_width-1:0] balance;
    wire wrong_psw;

    integer i;
    reg [password_width-1:0] password_reg [0:users_num-1];
    reg [balance_width-1:0] balance_reg  [0:users_num-1];

    cardhandling #(
        .card_width(card_width),
        .password_width(password_width),
        .balance_width(balance_width),
        .users_num(users_num)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .card_number(card_number),
        .op_done(op_done),
        .updated_balance(updated_balance),
        .password_input(password_input),
        .balance(balance),
        .wrong_psw(wrong_psw)
    );

    always begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        $readmemb("./Database/password_memory.txt", password_reg);
        $readmemb("./Database/balance_memory.txt" , balance_reg);
        rst = 0;
        @(negedge clk);
        for (i = 0; i < 1000; i=i+1) begin
            rst = $random();
            card_number = $random(); 
            op_done = $random();
            updated_balance = $random();
            password_input = $random();
            @(negedge clk);
            $readmemb("./Database/balance_memory.txt" , balance_reg);
        end
        $stop();
    end

    // psl rst_assertion: assert always( (!rst) -> next (!wrong_psw && !balance)) @(posedge clk);
    // psl correct_psw_assertion: assert always( (card_number < users_num && password_input == password_reg[card_number] && !op_done) -> next (!wrong_psw) abort !rst) @(posedge clk);
    // psl incorrect_psw_assertion: assert always( (card_number < users_num && password_input != password_reg[card_number] && !op_done) -> next (wrong_psw) abort !rst) @(posedge clk);
    // psl updated_balance_assertion: assert always( (card_number < users_num && op_done) -> next[1] (prev(updated_balance) == balance_reg[card_number]) abort !rst) @(posedge clk);
endmodule