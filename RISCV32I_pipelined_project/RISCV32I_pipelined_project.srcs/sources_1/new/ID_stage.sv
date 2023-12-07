`timescale 1ns / 1ps
module ID_stage(
    input clk,
    input rst,
    
    input logic regWrite,
    input logic branch,
    input logic isJalr,
    
    input logic [31:0] nextPC,
    input logic [31:0] PC,
    input logic [31:0] instruction,
    input logic [31:0] dataW,
    
    output logic [31:0] dataA, dataB, imm,jmpAdd
);
    
    logic [31:0] jalrAdd,brAdd;
    logic [4:0] addA, addB, addW;
    logic beq, blt;
    
    register_memory reg_mem(clk, rst, regWrite, addW, addA, addB, dataW, dataA, dataB);
    branch_comp bc(branch, dataA, dataB, beq, blt);
    imm_gen immg(instruction, imm);
    
    //combinational
    always_comb begin
        addA = instruction[19 : 15];
        addB = instruction[24:20];
        addW = instruction[11:7];
        
        jalrAdd = imm + dataA;
        brAdd = PC + imm;
        
        //logic
        
        if(isJalr)
            jmpAdd = jalrAdd;
        else 
            jmpAdd = brAdd;
    
    end
    
    
    
endmodule
