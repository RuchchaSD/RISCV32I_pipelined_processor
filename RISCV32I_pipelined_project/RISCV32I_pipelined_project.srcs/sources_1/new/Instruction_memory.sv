`timescale 1ns / 1ps
//Student ID - 200709K

module Instruction_memory#(
    parameter add_length = 9, 
    parameter width = 32
)(
    input clk,
    input rst,
    input logic [ width - 1 : 0 ] fullAddress,
    output logic [ width - 1 : 0] instruction
    
    );
    logic [add_length - 1 : 0] address; 
    logic  [width - 1:0] imem[ 2**(add_length-2) - 1:0];
    
    assign address = fullAddress[8:0];

    initial begin
        for (int i=0; i<2**(add_length-2); ++i) begin
            imem[i] = 0;
        end
    end


    //add instructions in here
    always_ff @(negedge rst) begin
        if(!rst) begin
//                imem[1] = 32'h001101B3; // ADD
//                imem[15] = 32'h00218663; // BEQ
                imem[15] = 32'h10218063; // BEQ                   
        end
    end
    
    
    assign instruction = imem[address[add_length - 1 : 2]];
endmodule
