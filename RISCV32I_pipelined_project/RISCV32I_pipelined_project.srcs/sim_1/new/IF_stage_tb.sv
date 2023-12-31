`timescale 1ns / 1ps

module IF_stage_tb;

    // Parameters
    parameter DATA_WIDTH = 32;

    // Testbench Signals
    reg clk;
    reg rst;
    reg [1:0] pcSel;
    reg [DATA_WIDTH-1:0] jmpAddress;
    wire [DATA_WIDTH-1:0] instruction_in_if_id;
    wire [DATA_WIDTH-1:0] PC_in_if_id;
    wire [DATA_WIDTH-1:0] PC4_in_if_id;

    // Instantiate the IF_stage module
    IF_stage #(.DATA_WIDTH(DATA_WIDTH)) if_stage_inst (
        .clk(clk),
        .rst(rst),
        .pcSel(pcSel),
        .jmpAddress(jmpAddress),
        .instruction_in_if_id(instruction_in_if_id),
        .PC_in_if_id(PC_in_if_id),
        .PC4_in_if_id(PC4_in_if_id)
    );

    // Clock Generation
    always #5 clk = ~clk; // Generate a clock with a period of 10ns

    // Initial Block
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        pcSel = 2'b00;
        jmpAddress = 0;

        // Reset the design
        #10;
        rst = 0;

        // Apply Test Vectors
        #60; // Wait for a few clock cycles
        pcSel = 1; // Test jump
        jmpAddress = 8;

        #60;
        pcSel = 0; // Normal increment
        jmpAddress = 0; // Not relevant in this case

        #60;
        pcSel = 2; // Hold the PC value
        jmpAddress = 32'h200; // Not relevant in this case

        #60;
        $finish; // End simulation
    end

    // Optional: Monitor changes
//    initial begin
//        $monitor("Time: %t, PC: %h, PC4: %h, Instruction: %h", $time, PC_in_if_id, PC4_in_if_id, instruction_in_if_id);
//    end

endmodule
