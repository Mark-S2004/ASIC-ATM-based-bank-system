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
    input wire psw_en,

    output reg [balance_width-1:0] balance,
    output reg card_out,
    output reg op_done,
    output reg error, 
    output reg start_timer, 
    output wire restart_timer 
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

reg [3:0] current_state, next_state ;
reg [balance_width-1:0] balance_reg ;
reg [1:0] error_count = 'b0 ;
reg [1:0] error_reg ;

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        balance <= 'b0 ;
    end
    else
    begin
        if(psw_en)
        begin
            balance <= current_balance ;
        end
        else
        begin
            balance <= balance_reg ;
        end
    end   
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        error_reg <= 2'b0 ;
    end
    else
    begin
        error_reg <= error_count ;
    end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        current_state <= idle ;
    end
    else
    begin
        current_state <= next_state ;
    end
end

always @ (*)
begin
    error_count = error_reg;

    case (current_state)
    idle : begin
        if(psw_en)
        begin
            next_state = lang ;
        end
        else
        begin
            next_state = idle ;
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
            end
            else if(operation == 2'b01)
            begin
                next_state = deposit ;
            end
            else if(operation == 2'b10)
            begin
                next_state = inquiry ;
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
        if(op_done)
        begin    
            next_state = another_service_state ;
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
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b0 ;
        card_out = 1'b0 ;
    end

    lang : begin
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;
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
        op_done = 1'b0 ;
        start_timer = 1'b1 ;
        if(!op_done) 
        begin
            if(value > current_balance)
            begin
                error = 1'b1 ;
                balance_reg = balance ;
                op_done = 1'b0 ;
            end
            else
            begin
                error = 1'b0 ;
                balance_reg = balance - value ;
                op_done = 1'b1 ;
            end
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

    deposit : begin
        op_done = 1'b0 ;
        start_timer = 1'b1 ;
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
        op_done = 1'b0 ;
        error = 1'b0 ;
        balance_reg = balance ;
        start_timer = 1'b1 ;

        if(timeout) 
        begin
            card_out = 1'b1 ;
        end
        else
        begin
            card_out = 1'b0 ;
        end  
    end
    endcase
end

assign restart_timer = another_service||(language==1'b0)||(language==1'b1)||(operation==2'b00)||(operation==2'b01)||(operation==2'b10);

endmodule