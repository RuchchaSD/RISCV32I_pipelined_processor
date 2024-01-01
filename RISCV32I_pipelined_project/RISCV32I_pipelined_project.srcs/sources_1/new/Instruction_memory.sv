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
            // imem[1] = 32'h001101B3; // ADD
            // imem[2] = 32'h401101B3; // SUB
            // imem[3] = 32'h001111B3; // SLL
            // imem[4] = 32'h001121B3; // SLT
            // imem[5] = 32'h001131B3; // SLTU
            // imem[6] = 32'h001141B3; // XOR
            // imem[7] = 32'h001151B3; // SRL
            // imem[8] = 32'h401151B3; // SRA
            // imem[9] = 32'h001161B3; // OR
            // imem[10] = 32'h001171B3; // AND
            // imem[11] = 32'h401141B3; // MUL
            // imem[12] = 32'h000162B7; // LUI
            // imem[13] = 32'h00019317; // AUIPC
            // imem[14] = 32'h033103E7; // JALR
            // imem[15] = 32'hFF710213; // ADDI
            // imem[16] = 32'h01712293; // SLTI
            // imem[17] = 32'h01713193; // SLTIU
            // imem[18] = 32'h01714193; // XORI
            // imem[19] = 32'h01716313; // ORI
            // imem[20] = 32'h01717193; // ANDI
            // imem[21] = 32'h00311393; // SLLI
            // imem[22] = 32'h00315413; // SRLI
            // imem[23] = 32'h40315493; // SRAI
            // imem[24] = 32'h00810583; // LB
            // imem[25] = 32'h00811603; // LH
            // imem[26] = 32'h00812683; // LW
            // imem[27] = 32'h00814703; // LBU
            // imem[28] = 32'h00815783; // LHU
            // imem[29] = 32'h00440223; // SB
            // imem[30] = 32'h00441223; // SH
            // imem[31] = 32'h00442223; // SW
            // imem[32] = 32'h00B58463; // BEQ
            // imem[33] = 32'h00B59463; // BNE
            // imem[34] = 32'h00B14463; // BLT
            // imem[35] = 32'h00B15463; // BGE
            // imem[36] = 32'h00B16463; // BLTU
            // imem[37] = 32'h00B17463; // BGEU
            // imem[38] = 32'h0088046F; // JAL
            // imem[39] = 32'h0020836B; // MEMCOPY

            imem[1] = 32'hFF710213; // ADDI
            imem[2] = 32'h01712293; // SLTI
            imem[3] = 32'h01713193; // SLTIU
            imem[4] = 32'h01714193; // XORI
            imem[5] = 32'h01716313; // ORI
            imem[6] = 32'h01717193; // ANDI
            imem[7] = 32'h00311393; // SLLI
            imem[8] = 32'h00315413; // SRLI
            imem[9] = 32'h40315493; // SRAI
        end
    end
    
    
    assign instruction = imem[address[add_length - 1 : 2]];
endmodule
