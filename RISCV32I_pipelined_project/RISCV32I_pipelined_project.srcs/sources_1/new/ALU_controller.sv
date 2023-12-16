`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 11:22:10
// Design Name: 
// Module Name: ALU_controller
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
module ALU_controller( 
    input logic [1:0] ALUOp,
    input logic [6:0] Funct7,
    input logic [2:0] Funct3,
    output logic [3:0] ALU_control
);
    
    always_comb begin
    case({Funct3,ALUOp})
        5'b11110 : ALU_control = 4'b0000;     // AND operation
        5'b11010 : ALU_control = 4'b0001;     // OR operation
        5'b10010 : if(Funct7 == 7'h00)
                       ALU_control = 4'b0011; // XOR operation
                   else if (Funct7 == 7'h20)
                       ALU_control = 4'b1001; //MUL operation
        5'b00010 : if(Funct7 == 7'h00)
                       ALU_control = 4'b0010; // ADD operation
                   else if (Funct7 == 7'h20)
                       ALU_control = 4'b0110; // SUB operation
        5'b00110 : ALU_control = 4'b0100;     // SLL operation
        5'b01010 : ALU_control = 4'b1010;     // SLT operation
        5'b01110 : ALU_control = 4'b0101;     // SLTU operation
        5'b10110 : if(Funct7 == 7'h00)
                       ALU_control = 4'b1000; // SRL operation
                   else if (Funct7 == 7'h20)
                       ALU_control = 4'b1100; // SRA operation            
        endcase
        
        if (ALUOp ==2'b00)
            ALU_control =  4'b0010; //LW / SW - add
    end
endmodule