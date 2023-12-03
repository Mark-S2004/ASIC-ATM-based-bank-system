module timer_tb;
    reg clk, rst, start, restart;
    reg [31:0] threshold;
    wire timeout;

    timer t1(clk, rst, start, restart, threshold, timeout);

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin
        rst = 0;
        start = 0;
        restart = 0;
        threshold = 32'd10;
        @(negedge clk);
        if (timeout == 1) $display("Error in rst");
        else $display("success");

        rst = 1;
        start = 1;
        restart = 1;
        @(negedge clk);
        if (timeout == 1) $display("Error in restart");
        else $display("success");

        restart = 0;
        repeat (10) @(negedge clk);
        if (timeout == 0) $display("Error in counter 10");
        else $display("success");

        start = 0;
        @(negedge clk);
        start = 1;
        @(negedge clk);
        repeat (5) @(negedge clk);
        if (timeout == 1) $display("Error in counter 5");
        else $display("success");

        restart = 0;
        repeat (11) @(negedge clk);
        if (timeout == 0) $display("Error in counter 11");
        else $display("success");

        start = 0;
        @(negedge clk);
        start = 1;
        @(negedge clk);
        repeat (15) @(negedge clk);
        if (timeout == 0) $display("Error in counter 15");
        else $display("success");

        $stop();
    end

    initial begin
        $monitor("rst = %b, start = %b, restart = %b, timeout = %b", rst, start, restart, restart, timeout);
    end
endmodule