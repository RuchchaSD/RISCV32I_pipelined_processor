`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2023 01:31:13 PM
// Design Name: 
// Module Name: Alu_Data_Forward
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


module ALU_data_forward(
    input logic regWrite_out_ex_mem,
    input logic regWrite_out_mem_wb,
    input logic [4:0] writeReg_out_ex_mem,
    input logic [4:0] writeReg_out_mem_wb,
    input logic [4:0] readReg1_out_id_ex,
    input logic [4:0] readReg2_out_id_ex,
    output logic [1:0] ExMUX3_sel,
    output logic [1:0] ExMUX4_sel
    );


    always_comb begin
        if(regWrite_out_mem_wb && (writeReg_out_mem_wb != 0) && (writeReg_out_mem_wb == readReg1_out_id_ex)) begin
            ExMUX3_sel = 2'b01;
        end
        else if(regWrite_out_ex_mem && (writeReg_out_ex_mem != 0) && (writeReg_out_ex_mem == readReg1_out_id_ex)) begin
            ExMUX3_sel = 2'b10;
        end
        else begin
            ExMUX3_sel = 2'b00;
        end
    end


    always_comb begin
        if(regWrite_out_mem_wb && (writeReg_out_mem_wb != 0) && (writeReg_out_mem_wb == readReg2_out_id_ex)) begin
            ExMUX4_sel = 2'b01;
        end
        else if(regWrite_out_ex_mem && (writeReg_out_ex_mem != 0) && (writeReg_out_ex_mem == readReg2_out_id_ex)) begin
            ExMUX4_sel = 2'b10;
        end
        else begin
            ExMUX4_sel = 2'b00;
        end
    end
endmodule
