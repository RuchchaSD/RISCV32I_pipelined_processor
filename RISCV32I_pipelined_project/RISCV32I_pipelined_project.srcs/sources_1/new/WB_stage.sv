`timescale 1ns / 1ps
module WB_stage(
    //inputs
    input logic clk,
    input logic rst,

    //input control signals
    input logic wbMuxSel_out_mem_wb,

    //input data
    input logic [31:0] aluOut_out_mem_wb,
    input logic [31:0] memOut_out_mem_wb,
    // input logic [4:0] writeReg_out_mem_wb,

    //outputs
    output logic [31:0] writeData_out_wb
    // output logic [4:0] writeReg_out_wb,
    );
    //Writeback mux
    always_comb
        if(wbMuxSel_out_mem_wb == 1'b0)
            writeData_out_wb = aluOut_out_mem_wb;
        else
            writeData_out_wb = memOut_out_mem_wb;

endmodule
