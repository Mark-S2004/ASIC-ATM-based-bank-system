module cardhandling #(parameter    card_width   = 6,
                                   password_width   = 16,
                                   balance_width   = 20,
                                   users_num = 10)
(
    input wire clk,
    input wire rst,
    input wire [card_width-1:0] card_number,
    input wire card_in,
    input wire card_out,
    input wire op_done,
    input wire [balance_width-1:0] updated_balance,
    input wire [password_width:0] password_input ;
    
    output reg [password_width-1:0] password,
    output reg [balance_width-1:0] balance,
    output reg psw_en,
    output reg wrong_psw

);

reg [password_width-1:0] password_reg [0:users_num-1] ;
reg [balance_width-1:0] balance_reg  [0:users_num-1] ;


always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        $readmemb("password_memory.txt", password_reg);
        $readmemb("balance_memory.txt" , balance_reg);

        password <= 1'b0;
        balance <= 1'b0;
    end
    else 
    begin
        if(card_number < users_num)
        begin
            if (card_in)
            begin
                password <= password_reg[card_number] ;
                balance  <= balance_reg[card_number]  ;
                if(password_input != password){
                    wrong_psw <= 1'b1;
                }
            end
            if (card_out || op_done)
            begin
                balance_reg[card_number] <= updated_balance;
            end
        end
        else 
        begin
            password <= 1'b0;
            balance <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        psw_en <= 1'b0;
    end
    else if(card_number < users_num)
    begin
        psw_en <= card_in;
    end
end


endmodule