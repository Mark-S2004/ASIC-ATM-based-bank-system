module ATM_Top_tb #(parameter   password_width = 4,
                                balance_width = 20, 
							    card_width = 3,
                                users_num = 7);
    reg clk, rst, language, another_service, card_in_reg;	
    reg [card_width-1:0] card_number;
    reg [password_width-1:0] password_input;
    reg [1:0] operation;
    reg [balance_width-1:0] value;
	reg [31:0] threshold;
    wire card_in, op_done, error, wrong_psw;
    wire [balance_width-1:0] updated_balance;
    integer i;

    reg [balance_width-1:0] balance_reg  [0:users_num-1];
    reg [password_width-1:0] password_reg [0:users_num-1];

    ATM_Top top
    (
        clk, rst, card_number, password_input, card_in, language, operation, value, another_service, updated_balance, op_done, error, wrong_psw
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        $readmemb("./Database/balance_memory.txt" , balance_reg);
        $readmemb("./Database/password_memory.txt", password_reg);
        rst = 0;
        @(negedge clk);
        for (i = 0; i < 1000; i=i+1) begin
            rst = $random();
            card_number = $random();
            card_in_reg = $random();
            password_input = $random();
            language = $random();
            operation = $random();
            value = $random();
            another_service = $random();
            @(negedge clk);
            $readmemb("./Database/balance_memory.txt" , balance_reg);
        end
        $stop();
    end
    assign card_in = card_in_reg;

    // psl rst_assertion: assert always( (!rst) -> next (!op_done && !error && !wrong_psw) ) @(posedge clk);
    // psl wrong_psw_assertion: assert always( (card_number < users_num && password_input != password_reg[card_number] && card_in) -> next (wrong_psw) abort !rst) @(posedge clk);
    // psl inquiry_assertion: assert always( (card_number < users_num && card_in && operation == 2'b11 && !another_service) -> next (updated_balance == balance_reg[card_number]) abort !rst) @(posedge clk);
endmodule