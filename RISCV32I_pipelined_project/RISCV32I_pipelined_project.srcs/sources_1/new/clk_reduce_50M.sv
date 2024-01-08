`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 05:12:35 PM
// Design Name: 
// Module Name: clk_reduce_50M
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


module clk_reduce_50M(
    input wire sysclk,
    input wire rst, // reset signal
    output reg clk  // initialize clk
//    output wire clk
);

    reg [31:0] count = 0; // initialize count

    always_ff @(posedge sysclk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk <= 0;
        end
        else begin
            count <= count + 1;
            if (count >= 25000000) begin // use >= for equal high and low periods
                clk <= ~clk;
                count <= 0;
            end
        end
    end
//    assign clk = sysclk;
endmodule
