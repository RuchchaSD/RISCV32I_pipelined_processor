`timescale 1ns / 1ps
module id_ex_latch#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic clk_id_ex,
        input logic rst_id_ex,
        input logic flush_id_ex,
        input logic stall_id_ex,
//INPUT
    //INPUT control signals
        //EXE_control_signals
        input logic [1:0] ALUSrc1_in_id_ex,
        input logic [1:0] ALUSrc2_in_id_ex,
        input logic [3:0] ALUOp_in_id_ex,
        
        //MEM_control_signals
        input logic [2:0] memRead_in_id_ex,
        input logic [2:0] memWrite_in_id_ex,

        //WB_control_signals
        input logic regWrite_in_id_ex,
        input logic wbMuxSel_in_id_ex,

    //INPUT data
        //data from IF stage
        input logic [ADDRESS_LENGTH-1:0] PC_in_id_ex,
        input logic [ADDRESS_LENGTH-1:0] PC4_in_id_ex,
        //data from ID stage
        input logic [ADDRESS_LENGTH-1:0] dataA_in_id_ex,
        input logic [ADDRESS_LENGTH-1:0] dataB_in_id_ex,
        input logic [ADDRESS_LENGTH-1:0] imm_in_id_ex,
        input logic [6:0] func7_in_id_ex,
        input logic [2:0] func3_in_id_ex,
        input logic [4:0] readReg1_in_id_ex,
        input logic [4:0] readReg2_in_id_ex,
        input logic [4:0] writeReg_in_id_ex,
        
        //MEM_data
        //WB_data       


//OUTPUT 
     //OUTPUT control signals
        //EXE_control_signals
        output logic [1:0] ALUSrc1_out_id_ex,
        output logic [1:0] ALUSrc2_out_id_ex,
        output logic [3:0] ALUOp_out_id_ex,// ????? here it is assigned a two bit value from datapath but here it is assigned a one bit value
        
        //MEM_control_signals
        output logic [2:0] memRead_out_id_ex,
        output logic [2:0] memWrite_out_id_ex,

        //WB_control_signals
        output logic regWrite_out_id_ex,
        output logic wbMuxSel_out_id_ex,

    //OUTPUT data
        //EXE_data
        output logic [ADDRESS_LENGTH-1:0] PC_out_id_ex,
        output logic [ADDRESS_LENGTH-1:0] PC4_out_id_ex,
        output logic [ADDRESS_LENGTH-1:0] dataA_out_id_ex,
        output logic [ADDRESS_LENGTH-1:0] dataB_out_id_ex,
        output logic [ADDRESS_LENGTH-1:0] imm_out_id_ex,
        output logic [6:0] func7_out_id_ex,
        output logic [2:0] func3_out_id_ex,
        output logic [4:0] readReg1_out_id_ex,
        output logic [4:0] readReg2_out_id_ex,
        //MEM_data
        //WB_data 
        output logic [4:0] writeReg_out_id_ex

        
    );
    
always_ff @(posedge clk_id_ex) begin
    if (rst_id_ex) begin
    // Reset all outputs to default values
        ALUSrc1_out_id_ex <= 0;
        ALUSrc2_out_id_ex <= 0;
        ALUOp_out_id_ex <= 0;
        memRead_out_id_ex <= 0;
        memWrite_out_id_ex <= 0;
        regWrite_out_id_ex <= 0;
        wbMuxSel_out_id_ex <= 0;
        PC_out_id_ex <= 0;
        PC4_out_id_ex <= 0;
        dataA_out_id_ex <= 0;
        dataB_out_id_ex <= 0;
        imm_out_id_ex <= 0;
        func7_out_id_ex <= 0;
        func3_out_id_ex <= 0;
        readReg1_out_id_ex <= 0;
        readReg2_out_id_ex <= 0;
        writeReg_out_id_ex <= 0;
    end else if (flush_id_ex) begin
    // Flush: Reset control signals, but leave data intact
        ALUSrc1_out_id_ex <= 0;
        ALUSrc2_out_id_ex <= 0;
        ALUOp_out_id_ex <= 0;
        memRead_out_id_ex <= 0;
        memWrite_out_id_ex <= 0;
        regWrite_out_id_ex <= 0;
        wbMuxSel_out_id_ex <= 0;
    // Data lines will get the next value, thus not resetting them
        PC_out_id_ex <= PC_in_id_ex;
        PC4_out_id_ex <= PC4_in_id_ex;
        dataA_out_id_ex <= dataA_in_id_ex;
        dataB_out_id_ex <= dataB_in_id_ex;
        imm_out_id_ex <= imm_in_id_ex;
        func7_out_id_ex <= func7_in_id_ex;
        func3_out_id_ex <= func3_in_id_ex;
        readReg1_out_id_ex <= readReg1_in_id_ex;
        readReg2_out_id_ex <= readReg2_in_id_ex;
        writeReg_out_id_ex <= writeReg_in_id_ex;
    end else if (!stall_id_ex) begin
    // Normal operation: Transfer input to output
        ALUSrc1_out_id_ex <= ALUSrc1_in_id_ex;
        ALUSrc2_out_id_ex <= ALUSrc2_in_id_ex;
        ALUOp_out_id_ex <= ALUOp_in_id_ex; //<------------------over here
        memRead_out_id_ex <= memRead_in_id_ex;
        memWrite_out_id_ex <= memWrite_in_id_ex;
        regWrite_out_id_ex <= regWrite_in_id_ex;
        wbMuxSel_out_id_ex <= wbMuxSel_in_id_ex;
        PC_out_id_ex <= PC_in_id_ex;
        PC4_out_id_ex <= PC4_in_id_ex;
        dataA_out_id_ex <= dataA_in_id_ex;
        dataB_out_id_ex <= dataB_in_id_ex;
        imm_out_id_ex <= imm_in_id_ex;
        func7_out_id_ex <= func7_in_id_ex;
        func3_out_id_ex <= func3_in_id_ex;
        readReg1_out_id_ex <= readReg1_in_id_ex;
        readReg2_out_id_ex <= readReg2_in_id_ex;
        writeReg_out_id_ex <= writeReg_in_id_ex;
    end
    // If stall_id_ex is high, maintain the current state
end
    
    
endmodule