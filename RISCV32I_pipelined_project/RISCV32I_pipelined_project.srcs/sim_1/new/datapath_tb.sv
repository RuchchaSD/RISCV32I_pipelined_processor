`timescale 1ns / 1ps

module datapath_tb;

    // Parameter
    parameter ADDRESS_LENGTH = 32;

    // Inputs
    reg clk;
    reg rst;
    logic [31:0] PC_in_if_id;
    logic [31:0] memOut_out_mem_wb;
    logic [31:0] aluOut_in_ex_mem;

    // Instantiate the Unit Under Test (UUT)
    RISCV32I_pipelined #(.ADDRESS_LENGTH(ADDRESS_LENGTH)) uut (
        .clk(clk),
        .rst(rst),
        .PC_in_if_id(PC_in_if_id),
        .memOut_out_mem_wb(memOut_out_mem_wb),
        .aluOut_in_ex_mem(aluOut_in_ex_mem)
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
