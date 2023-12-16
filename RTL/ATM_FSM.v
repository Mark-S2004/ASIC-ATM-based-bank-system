module ATM_FSM #(parameter  balance_width = 20 )
(
    input wire clk,
    input wire rst,
    input wire timeout,
    input wire wrong_psw,
    input wire [balance_width-1:0] current_balance,
    input wire language,  // Arabic(1'b1), English(1'b0)
    input wire [1:0] operation,  // withdraw(2'b00), deposit(2'b01), balance(2'b10)
    input wire [balance_width-1:0] value,
    input wire another_service,

    output reg [balance_width-1:0] balance,
    output reg card_out = 0,
    output reg op_done,
    output reg error, 
    output reg start_timer, 
    output reg restart_timer 
);

localparam  idle = 4'b0000 ,
            lang = 4'b0001 ,
            id = 4'b0010 ,
            psw = 4'b0011 ,
            op = 4'b0100 ,
            withdraw = 4'b0101 ,
            deposit = 4'b0110 ,
            inquiry = 4'b0111 ,
            another_service_state = 4'b1000 ;

reg [3:0] current_state, next_state = idle ;
reg [balance_width-1:0] balance_reg ;
reg [1:0] error_count = 'b0 ;
reg [1:0] error_reg ;

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        balance <= 'b0 ;
        error_reg <= 2'b0 ;
        current_state <= idle ;
    end
    else
    begin
        error_reg <= error_count ;
        current_state <= next_state ;
        if (!card_out)
            balance <= current_balance;
        else
            balance <= balance_reg;
    end   
end

always @ (*)
begin
    error_count = error_reg;

    case (current_state)
    idle : begin
        if(op_done && !another_service)
        begin
            next_state = idle ;
        end
        else
        begin
            next_state = lang ;
            restart_timer = 1;
        end
    end

    lang : begin
        if(timeout)
        begin
            next_state = idle ;
        end
        else
        begin
            if(language == 1'b0 || language == 1'b1)
            begin
                next_state = psw ;
                restart_timer = 1;
            end
            else
            begin
                next_state = lang ;
            end
        end
    end

    psw : begin
        error_count = error_reg;
        if(timeout)
        begin
            next_state = idle ;
        end
        if(wrong_psw)
        begin
            if(error_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = idle ;
            end
            else
            begin
                error_count = error_reg + 1'b1 ;
                next_state = psw ;
            end    
        end
        else
        begin
            error_count = 2'b0;
            next_state = op ;
            restart_timer = 1;
        end
    end

    op : begin
        if(timeout) 
        begin
            next_state = idle ;
        end
        else
        begin
            if(operation == 2'b00)
            begin
                next_state = withdraw ;
                restart_timer = 1;
            end
            else if(operation == 2'b01)
            begin
                next_state = deposit ;
                restart_timer = 1;
            end
            else if(operation == 2'b10)
            begin
                next_state = inquiry ;
                restart_timer = 1;
            end
            else
            begin
                next_state = op ;
            end
        end
    end

    withdraw : begin
        error_count = error_reg;
        if(timeout)
        begin
            next_state = idle ;
        end
        if(op_done && !error)
        begin   
            next_state = another_service_state ;
            restart_timer = 1;
        end
        else
        begin
            if(error_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = idle ;
            end
            else
            begin
                error_count = error_reg + 1'b1 ;
                next_state = withdraw ;
                restart_timer = 1;
            end
        end

    end

    deposit : begin
        error_count = error_reg;
        if(timeout)
        begin
            next_state = idle ;
        end
        if(op_done)
        begin
            next_state = another_service_state ;
            restart_timer = 1;
        end 
        else 
        begin
            if(error_reg == 2'b10)
            begin
                error_count = 2'b0;
                next_state = idle ;
            end
            else
            begin
                error_count = error_reg + 1'b1 ;
                next_state = deposit ;
                restart_timer = 1;
            end
        end

    end

    inquiry : begin
        if(timeout)
        begin
            next_state = idle ;
        end
        else
        begin
            next_state = another_service_state ;
            restart_timer = 1;
        end
    end

    another_service_state : begin
        if(timeout)
        begin
            next_state = idle ;
        end
        if(another_service)
        begin
            next_state = op ;
            restart_timer = 1;
        end 
        else
        begin
            next_state = idle ;
        end
    end

    endcase
end

always @ (*)
begin

    case (current_state)
    idle : begin
        balance_reg = balance ;
        card_out = 1;
        start_timer = 1'b0 ;
    end

    lang : begin
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;
        if(language)
        begin
            $display("Arabic");
        end
        else
        begin
            $display("English");
        end

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    psw : begin
        op_done = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;

        if(wrong_psw || timeout)
        begin
            card_out=1'b1;
            error=1'b1;
        end
        else
        begin
            card_out = 1'b0 ;
            error = 1'b0;
        end
    end

    op : begin
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    withdraw : begin
        start_timer = 1'b1 ;
        restart_timer = 0 ;
        if(value > current_balance)
        begin
            error = 1'b1 ;
            balance_reg = balance ;
            if (error_reg == 2'b10)
                op_done = 1;
            else
                op_done = 0;
        end
        else
        begin
            error = 1'b0 ;
            balance_reg = balance - value ;
            op_done = 1'b1 ;
        end

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end

    deposit : begin
        op_done = 1'b0 ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;
        if(!op_done) 
        begin
                error = 1'b0 ;
                balance_reg = balance + value ;
                op_done = 1'b1 ;
        end
        else
        begin
            error = 1'b0 ;
            balance_reg = balance ;
            op_done = 1'b1 ;
        end

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end   
    end

    inquiry : begin
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;
        if(!op_done) 
        begin
                error = 1'b0 ;
                balance_reg = balance ;
                $display("%d",balance);
                op_done = 1'b1 ;
        end
        else
        begin
            error = 1'b0 ;
            balance_reg = balance ;
            op_done = 1'b1 ;
        end

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end
    another_service_state : begin
        op_done = 1;
        error = 1'b0 ;
        balance = balance_reg ;
        start_timer = 1'b1 ;
        restart_timer = 0 ;

        if(another_service && !timeout)
        begin
            card_out = 0;
            if (another_service) op_done = 1'b0 ;
        end 
        else
        begin
            card_out = 1;
        end
    end
    endcase
end
endmodule