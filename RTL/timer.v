module timer #(parameter threshold = 32'd10)
(
    input wire clk,
    input wire rst,
    input wire start,
    input wire restart,
    output reg timeout
);

reg[31:0] counter;

always @(posedge clk or negedge rst)
    begin 
        if (!rst)
        begin
            counter <= 1'b0;
            timeout <= 1'b0;
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
               timeout <= 1'b1;
               counter <= 1'b0;
            end
        end
        else
        begin
            counter <= 1'b0;
            timeout <= 1'b0;
        end
    end
endmodule 

    
            
