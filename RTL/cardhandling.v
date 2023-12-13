module cardhandling #(parameter    card_width   = 3,
                                   password_width   = 4,
                                   balance_width   = 20,
                                   users_num = 7)
(
    input wire clk,
    input wire rst,
    input wire [card_width-1:0] card_number,
    input wire card_in,
    input wire op_done,
    input wire [balance_width-1:0] updated_balance,
    input wire [password_width-1:0] password_input,
    output reg [balance_width-1:0] balance,
    output reg wrong_psw

);

reg [password_width-1:0] password_reg [0:users_num-1] ;
reg [balance_width-1:0] balance_reg  [0:users_num-1] ;



always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        $readmemb("./Database/password_memory.txt", password_reg);
        $readmemb("./Database/balance_memory.txt" , balance_reg);

        balance <= 1'b0;
        wrong_psw <= 1'b0;
    end
    else 
    begin
        wrong_psw <= 1'b0;
        if(card_number < users_num)
        begin
            if (card_in)
            begin
            
                balance <= balance_reg[card_number]  ;
                if(password_input != password_reg[card_number])
                    wrong_psw <= 1'b1;
            end
            if ((!card_in)|| op_done)
            begin
                balance_reg[card_number] = updated_balance;
                $writememb("./Database/balance_memory.txt",balance_reg,0,users_num-1);
            end
        end
        else 
        begin
            balance <= 1'b0;
            wrong_psw <= 1'b0;
        end
    end
end

endmodule