`timescale 1ns / 1ps

module datapath_tb;

    // Parameter
    parameter ADDRESS_LENGTH = 32;

    // Inputs
    reg clk;
    reg rst;

    // Instantiate the Unit Under Test (UUT)
    RISCV32I_pipelined #(.ADDRESS_LENGTH(ADDRESS_LENGTH)) uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Clock with a period of 20 ns
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;

        // Wait for the reset
        #100;
        rst = 0;

        // Add additional stimulus here
        // For instance, you can simulate different input scenarios and observe the outputs

        // Finish simulation after a certain time
        #1000;
        $finish;
    end

    // Optional: Add monitoring or checking logic here
    // For example, you can use $monitor to observe changes in signals
    // $monitor("Time = %t, Signal = %h", $time, signal_name);

endmodule
