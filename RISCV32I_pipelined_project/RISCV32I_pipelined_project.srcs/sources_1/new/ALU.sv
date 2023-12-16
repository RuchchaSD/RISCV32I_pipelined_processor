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
        4'b0000:ALUResult = SrcA & SrcB; // AND
        4'b0001:ALUResult = SrcA | SrcB;//OR
        4'b0011:ALUResult = SrcA ^ SrcB;//XOR
        4'b0010:ALUResult = SrcA + SrcB;//ADD
        4'b0110:ALUResult = $signed(SrcA) - $signed(SrcB);//Subtract
        4'b0100:ALUResult = SrcA << SrcB; //SLL
        4'b0101:ALUResult = SrcA < SrcB; //SLTU
        4'b1010:ALUResult = ($signed(SrcA)<$signed(SrcB)); //SLT
        4'b0111:ALUResult = SrcA - SrcB;
        4'b1000:ALUResult = SrcA >> SrcB;//SRL
        4'b1100:ALUResult = $signed(SrcA) >>> SrcB;//SRA
        4'b1001:ALUResult = SrcA * SrcB;
        default: 
                ALUResult = 'b0;
        endcase
    end
endmodule
