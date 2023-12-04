module cardhandling_tb;
    // inputs
  parameter card_width = 6;
  parameter password_width = 16;
  parameter balance_width = 20;
  parameter users_num = 10;

  reg clk;
  reg rst;
  reg [card_width-1:0] card_number;
  reg card_in;
  reg card_out;
  reg op_done;

  reg [balance_width-1:0] updated_balance;
  reg [password_width-1:0] password_input;

    // outputs
  wire [balance_width-1:0] balance;
  wire psw_en;
  wire wrong_psw;

// connecting ports
  cardhandling #(
    .card_width(card_width),
    .password_width(password_width),
    .balance_width(balance_width),
    .users_num(users_num)
  ) dut (
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
  
// bos el Period 10 f 5 high w 5 low 
// grb dwl 
 always begin
    //  clk = 0;
    // #5;
    // clk = 1;
    // #5;

    #5;
    clk = ~clk;
  end

  initial begin
    rst = 1'b0;
    card_number = 6'b000000;
    card_in = 1'b0;
    card_out = 1'b0;
    op_done = 1'b0;
    updated_balance = 20'b0;
    password_input = 16'b0;

    #10;
    rst = 1'b1;
    #10;
    rst = 1'b0;

    // Test scenario
    card_number = 6'b000001;
    card_in = 1'b1;
    password_input = 16'b1010101010101010;
    #20;
    card_out = 1'b1;
    #10;
    op_done = 1'b1;
    updated_balance = 20'b11001100110011001100;
    #10;

    $display("balance = %b", balance);
    $display("psw_en = %b", psw_en);
    // $display("wrong_psw = %b", wrong_psw);

    #10;
    $stop();
  end

endmodule