`timescale 1ns / 1ps

//This module is the top module of the pipeline and connects all the stages together. each stage is a module and each latch is a module.
//This module also contains the data_forward unit and hazard control unit.
//Each stage is connected to the next stage through a latch.


module RISCV32I_pipelined#(
        parameter ADDRESS_LENGTH = 32
    )(
    //inputs
    input logic clk,
    input logic rst


    
    );

    //initiations
    logic [ADDRESS_LENGTH-1:0] pc_in_if_id, pc4_in_if_id, pc_out_if_id, pc4_out_if_id, instruction_in_if_id, 
                               instruction_out_if_id,branchAddress;

    logic [1:0] pcSel;
    logic stall_if_id;

    //ID stage
    // logic memRead_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_ex_mem, regWrite_out_mem_wb,stall_if_id, flush_if_id, stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex,
    //       ALUSrc2_in_id_ex, stall_ex_mem, flush_ex_mem, memRead_in_ex_mem, memWrite_in_id_ex, stall_mem_wb, flush_mem_wb, regWrite_in_ex_mem, wbMuxSel_in_ex_mem;
    // logic [6:0] func7_in_id_ex;
    // logic [2:0] func3_in_id_ex;
    // logic [3:0] ALUOp_in_id_ex;
    // logic[1:0] pcSel_out_id;
    // logic [31:0] PC_out_if_id, PC4_out_if_id, instruction_out_if_id, aluOut_out_ex_mem, writeData_out_wb, memOut_out_mem_wb,jmpAddress_out_id,
    //                 writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex,PC_in_if_id, PC4_in_if_id;
    // logic [4:0] writeReg_out_id_ex, writeReg_out_ex_mem, writeReg_out_mem_wb,writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex;






//IF stage
    IF_stage IF_stage_inst(clk, rst, pcSel_out_id, jmpAddress_out_id, instruction_in_if_id, PC_in_if_id, PC4_in_if_id);

    // wire ;
    wire [1:0] ;
    // wire [2:0] ;
    // wire [3:0] ;
    // wire [4:0] ;
    wire [31:0]  instruction_in_if_id, PC_in_if_id, PC4_in_if_id;

    if_id_latch IF_ID_latch_inst(clk, rst, stall_if_id,  PC_in_if_id, PC4_in_if_id, instruction_in_if_id, pc_out_if_id,
     pc4_out_if_id, instruction_out_if_id);

    wire stall_if_id,flush_if_id;
    // wire [1:0] ;
    // wire [2:0] ;
    // wire [3:0] ;
    // wire [4:0] ;
    wire [31:0] PC_out_if_id, pc4_out_if_id, instruction_out_if_id;
//ID stage
    ID_stage ID_stage_inst(clk, rst, memRead_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_ex_mem, regWrite_out_mem_wb,
     PC_out_if_id, pc4_out_if_id, instruction_out_if_id, writeReg_out_id_ex, aluOut_out_ex_mem, writeReg_out_ex_mem, writeReg_out_mem_wb, 
     writeData_out_wb, memOut_out_mem_wb, 
     
     stall_if_id, flush_if_id, pcSel_out_id, stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex, 
     ALUSrc2_in_id_ex, ALUOp_in_id_ex, stall_ex_mem, flush_ex_mem, memRead_in_ex_mem, memWrite_in_id_ex, stall_mem_wb, flush_mem_wb, 
     regWrite_in_ex_mem, wbMuxSel_in_ex_mem, jmpAddress_out_id, writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex, 
     func7_in_id_ex, func3_in_id_ex, writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex);

    wire  pcSel_out_id, stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex,stall_ex_mem, 
    flush_ex_mem, memRead_in_ex_mem, memWrite_in_id_ex,stall_mem_wb, flush_mem_wb, regWrite_in_ex_mem, wbMuxSel_in_ex_mem,;
    wire [1:0] ;
    wire [2:0] func3_in_id_ex;
    wire [3:0] ALUOp_in_id_ex,;
    wire [4:0] writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex;
    wire [6:0] func7_in_id_ex;
    wire [31:0] jmpAddress_out_id, writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex;

    id_ex_latch ID_EX_latch_inst(clk, rst, flush_id_ex, stall_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex, ALUOp_in_id_ex, 
    memRead_in_ex_mem, memWrite_in_id_ex, regWrite_in_ex_mem, wbMuxSel_in_ex_mem, PC_in_if_id, PC4_in_if_id, dataA_in_id_ex, dataB_in_id_ex, 
    imm_in_id_ex, func7_in_id_ex, func3_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex, writeReg_in_id_ex,

    ALUSrc1_out_id_ex, ALUSrc2_out_id_ex, ALUOp_out_id_ex, memRead_out_id_ex, memWrite_out_id_ex, regWrite_out_id_ex, wbMuxSel_out_id_ex,
    PC_out_id_ex, PC4_out_id_ex,dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex, func7_out_id_ex, func3_out_id_ex, readReg1_out_id_ex, readReg2_out_id_ex, 
    writeReg_out_id_ex);

    wire ALUSrc1_out_id_ex, ALUSrc2_out_id_ex, ALUOp_out_id_ex, memRead_out_id_ex, memWrite_out_id_ex, regWrite_out_id_ex, wbMuxSel_out_id_ex;
    wire [1:0] ;
    wire [2:0] ;
    wire [3:0] ;
    wire [6:0] func7_out_id_ex;
    wire [4:0] writeReg_out_id_ex,readReg1_out_id_ex, readReg2_out_id_ex;
    wire [31:0] PC_out_id_ex, PC4_out_id_ex, dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex;
//EX stage
    EX_stage EX_stage_inst(dataA_out_id_ex,writeData_out_wb,);

    wire memRead_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_ex_mem,;
    wire [1:0] ;
    wire [2:0] ;
    wire [3:0] ;
    wire [4:0] ;
    wire [31:0] aluOut_out_ex_mem;


    ex_mem_latch EX_MEM_latch_inst(clk_ex_mem, rst_ex_mem, flush_ex_mem, stall_ex_mem, aluOut_in_ex_mem, writeReg_in_ex_mem, 
    memRead_in_ex_mem, memWrite_in_ex_mem, regWrite_in_ex_mem, wbMuxSel_in_ex_mem, aluOut_out_ex_mem, writeReg_out_ex_mem, 
    memRead_out_ex_mem, memWrite_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_id_ex);

    wire ;
    wire [1:0] ;
    wire [2:0] ;
    wire [3:0] ;
    wire [4:0] writeReg_out_ex_mem;
    wire [31:0] aluOut_out_ex_mem,;

//Mem stage
    MEM_stage MEM_stage_inst(clk, rst, aluOut_in_ex_mem, writeReg_in_ex_mem, memRead_in_ex_mem, memWrite_in_ex_mem, regWrite_in_ex_mem, 
    wbMuxSel_in_ex_mem, aluOut_out_ex_mem, writeReg_out_ex_mem, memRead_out_ex_mem, memWrite_out_ex_mem, regWrite_out_ex_mem, 
    wbMuxSel_out_ex_mem, writeData_in_mem_wb, memOut_in_mem_wb, regWrite_in_mem_wb, wbMuxSel_in_mem_wb, writeData_out_mem_wb, 
    memOut_out_mem_wb, regWrite_out_mem_wb, wbMuxSel_out_mem_wb);

    wire ;
    wire [1:0] ;
    wire [2:0] ;
    wire [3:0] ;
    wire [4:0] ;
    wire [31:0] ;


    mem_wb_latch MEM_WB_latch_inst(clk_mem_wb, rst_mem_wb, flush_mem_wb, stall_mem_wb, writeData_in_mem_wb, memOut_in_mem_wb, 
    regWrite_in_mem_wb, wbMuxSel_in_mem_wb, writeData_out_mem_wb, memOut_out_mem_wb, regWrite_out_mem_wb, wbMuxSel_out_mem_wb);

    wire regWrite_out_mem_wb;
    wire [1:0] ;
    wire [2:0] ;
    wire [3:0] ;
    wire [4:0] writeReg_out_mem_wb,;
     
    wire [31:0] writeData_out_wb, memOut_out_mem_wb;
// wb stage
    WB_stage WB_stage_inst(clk, rst, writeData_in_mem_wb, memOut_in_mem_wb, regWrite_in_mem_wb, wbMuxSel_in_mem_wb, writeData_out_mem_wb, 
    memOut_out_mem_wb, regWrite_out_mem_wb, wbMuxSel_out_mem_wb, writeData_out_wb, memOut_out_wb, regWrite_out_wb, wbMuxSel_out_wb);





endmodule