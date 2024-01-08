`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 10:15:00 AM
// Design Name: 
// Module Name: RISCV32_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISCV32_top(
    input logic sysclk,
    input logic rst,
    input logic [0:2] outSel,
    input logic [0:2] bitlocation,
    output logic [0:3] out
    );
    
    logic clk;
    logic [0:31] temp, PC, dataW, aluOut; 
    
    clk_reduce_50M cr(sysclk, rst ,clk);
    RISCV32I_pipelined rv(clk, rst,PC, dataW, aluOut);
    
    always_comb begin
        case(outSel)
            0 : temp = aluOut;
            1 : temp = dataW;
            2 : temp = PC; 
        endcase
    end
    
    always_comb begin
        case(bitlocation)
            7 : out = temp[0:3];
            6 : out = temp[4:7];
            5 : out = temp[8:11];
            3 : out = temp[12:15];
            4 : out = temp[16:19];
            2 : out = temp[20:23];
            1 : out = temp[24:27];
            0 : out = temp[28:31];
        endcase
    end
    
    
endmodule
