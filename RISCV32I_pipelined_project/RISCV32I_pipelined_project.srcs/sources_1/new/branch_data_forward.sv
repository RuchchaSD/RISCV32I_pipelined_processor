`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2023 08:12:59 AM
// Design Name: 
// Module Name: branch_data_forward
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

//check with hazard control unit's action

module branch_data_forward(
    input logic regWrite_out_ex_mem,
    input logic wbMuxsel_out_ex_mem,
    input logic regWrite_out_mem_wb,
    input logic wbMuxsel_out_mem_wb,

    input logic [4:0] readReg1_in_id_ex,
    input logic [4:0] readReg2_in_id_ex,
    input logic [4:0] writeReg_out_ex_mem,
    input logic [4:0] writeReg_out_mem_wb,

    output logic [1 : 0] brach_mux1,// 00: no forwarding, 01: forward ALUout from EX/MEM, 10: forward Wbdata from MEM/WB
    output logic [1 : 0] brach_mux2
    );
    always_comb begin
        if (regWrite_out_ex_mem && (readReg1_in_id_ex == writeReg_out_ex_mem) && wbMuxsel_out_ex_mem == 1'b0 ) begin
            brach_mux1 = 2'b01;
        end
        else if (regWrite_out_mem_wb && (readReg1_in_id_ex == writeReg_out_mem_wb) && wbMuxsel_out_mem_wb == 1'b1) begin
            brach_mux1 = 2'b10;
        end
        else begin
            brach_mux1 = 2'b00;
        end


        if (regWrite_out_ex_mem && (readReg2_in_id_ex == writeReg_out_ex_mem) && wbMuxsel_out_ex_mem == 1'b0 ) begin
            brach_mux2 = 2'b01;
        end
        else if (regWrite_out_mem_wb && (readReg2_in_id_ex == writeReg_out_mem_wb) && wbMuxsel_out_mem_wb == 1'b1) begin
            brach_mux2 = 2'b10;
        end
        else begin
            brach_mux2 = 2'b00;
        end
    end
endmodule
