module timer_tb;
    reg clk, rst, start, restart;
    reg [31:0] threshold;
    wire timeout;
    integer i;

    timer t1(clk, rst, start, restart, timeout);

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        rst = 0;
        start = 0;
        restart = 0;
        @(negedge clk);
        if (timeout == 1) $display("Error in rst");
        else $display("success");

        rst = 1;
        start = 1;
        restart = 1;
        @(negedge clk);
        if (timeout == 1) $display("Error in restart");
        else $display("success");

        start = 0;
        @(negedge clk);
        start = 1;
        @(negedge clk);
        repeat (5) @(negedge clk);
        if (timeout) $display("Error in counter 5");
        else $display("success");

        restart = 0;
        repeat (11) @(negedge clk);
        if (!timeout) $display("Error in counter 11");
        else $display("success");

        start = 0;
        @(negedge clk);
        start = 1;
        @(negedge clk);
        repeat (15) @(negedge clk);
        if (!timeout) $display("Error in counter 15");
        else $display("success");

        for (i = 0; i < 1000; i=i+1) begin
            rst = $random();
            start = $random();
            restart = $random();
            repeat (12) @(negedge clk);
        end

        $stop();
    end

    // psl start_assertion: assert always( (start && !restart) -> next[11] (timeout) abort !rst) @(posedge clk);
    // psl restart_assertion: assert always( (restart) -> next (prev(timeout) == timeout) abort !rst) @(posedge clk);
    // psl rst_assertion: assert always( (!rst) -> next (!timeout)) @(posedge clk);
endmodule