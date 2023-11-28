module timer (
    input wire clk,
    input wire rst,
    input wire start,
    input wire restart,
    input wire [31:0] threshold,
    output reg time_out

);

reg[31:0] counter;

always @(posedge clk or negedge rst)
    begin 
        if (!rst)
        begin
            counter <= 1'b0;
            time_out <= 1'b0;
        end
        else if (start)
        begin
            if (restart)
            begin
            counter <= 1'b0;
            end
            else
            begin
            counter <= counter + 1'b1;
            end
            if (counter == threshold)
            begin
               time_out <= 1'b1;
               counter <= 1'b0;
            end
        end
        else
        begin
            counter <= 1'b0;
        end
    end
endmodule 

    
            
