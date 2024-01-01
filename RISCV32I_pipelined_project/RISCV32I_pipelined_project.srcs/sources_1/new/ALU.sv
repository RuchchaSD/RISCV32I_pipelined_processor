`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 11:20:16
// Design Name: 
// Module Name: ALU
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
module ALU(
    input logic [31:0]  SrcA,
    input logic [31:0]  SrcB,
    input logic [3:0]   ALU_control,
    output logic[31:0]  ALUResult

    );
    always_comb
        begin
        ALUResult = 'd0;

        case(ALU_control)
            4'h1: ALUResult <= $signed(SrcA) + $signed(SrcB); //ADD
            4'h2: ALUResult <= SrcA - SrcB; //SUB
            4'h3: ALUResult <= SrcA << SrcB; //SLL
            4'h4: ALUResult <= $signed(SrcA) < $signed(SrcB); //SLT
            4'h5: ALUResult <= SrcA < SrcB; //SLTU
            4'h6: ALUResult <= SrcA ^ SrcB; //XOR
            4'h7: ALUResult <= $signed(SrcA) >>> SrcB; //SRA
            4'h8: ALUResult <= SrcA >> SrcB; //SRL
            4'h9: ALUResult <= SrcA | SrcB; //OR
            4'ha: ALUResult <= SrcA & SrcB; //AND
            4'hb: ALUResult <= SrcA == SrcB; //BEQ
            4'hc: ALUResult <= SrcA != SrcB; //BNE
            4'hd: ALUResult <= $signed(SrcA) >= $signed(SrcB); //BGE
            4'he: ALUResult <= SrcA >= SrcB; //BGEU
            4'hf: ALUResult <= SrcA * SrcB; //MUL
            default: ALUResult <= 31'b0; //NOP
        endcase
    end
endmodule

        // 4'b1111:ALUResult = SrcA & SrcB; // AND
        // 4'b0001:ALUResult = SrcA | SrcB;//OR
        // 4'b0011:ALUResult = SrcA ^ SrcB;//XOR
        // 4'b0010:ALUResult = SrcA + SrcB;//ADD
        // 4'b0110:ALUResult = $signed(SrcA) - $signed(SrcB);//Subtract
        // 4'b0100:ALUResult = SrcA << SrcB; //SLL
        // 4'b0101:ALUResult = SrcA < SrcB; //SLTU
        // 4'b1010:ALUResult = ($signed(SrcA)<$signed(SrcB)); //SLT
        // 4'b0111:ALUResult = SrcA - SrcB;
        // 4'b1000:ALUResult = SrcA >> SrcB;//SRL
        // 4'b1100:ALUResult = $signed(SrcA) >>> SrcB;//SRA
        // 4'b1001:ALUResult = SrcA * SrcB;
        // default: 
        //         ALUResult = 'b0;