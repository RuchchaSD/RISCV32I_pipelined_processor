`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 11:18:09
// Design Name: 
// Module Name: MUX31
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
module MUX31(
    input logic [31:0] d0,
    input logic [31:0] d1,
    input logic [31:0] d2,
    input logic [1:0] s,
    output logic [31:0] y
);

always @* begin
    case (s)
        2'b01: y <= d1;
        2'b10: y <= d2;
        default: y <= d0;
    endcase
end

endmodule
