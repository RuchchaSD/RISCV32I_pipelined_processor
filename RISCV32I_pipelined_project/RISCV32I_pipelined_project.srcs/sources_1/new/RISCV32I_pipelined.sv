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
    

    

//latches
    if_id_latch IF_ID_latch_inst(
        .clk_if_id(clk),
        .rst_if_id(rst),
        .stall_if_id(stall_if_id),

        .pc_in_if_id(pc_in_if_id),
        .pc4_in_if_id(pc4_in_if_id),
        .instruction_in_if_id(instruction_in_if_id),

        .pc_out_if_id(pc_out_if_id),
        .pc4_out_if_id(pc4_out_if_id),
        .instruction_out_if_id(instruction_out_if_id)
    );

    // ID-EX_latch ID_EX_latch_inst(
    //     .clk(clk),
    //     .rst(rst),
    //     .pc_in_if_id(pc_in_if_id),
    //     .pc4_in_if_id(pc4_in_if_id),
    //     .instruction_in_if_id(instruction_in_if_id),
    //     .pc_out_if_id(pc_out_if_id),
    //     .pc4_out_if_id(pc4_out_if_id),
    //     .instruction_out_if_id(instruction_out_if_id)
    // );

    // EX-MEM_latch EX_MEM_latch_inst(
    //     .clk(clk),
    //     .rst(rst),
    //     .pc_in_if_id(pc_in_if_id),
    //     .pc4_in_if_id(pc4_in_if_id),
    //     .instruction_in_if_id(instruction_in_if_id),
    //     .pc_out_if_id(pc_out_if_id),
    //     .pc4_out_if_id(pc4_out_if_id),
    //     .instruction_out_if_id(instruction_out_if_id)
    // );

    // MEM-WB_latch MEM_WB_latch_inst(
    //     .clk(clk),
    //     .rst(rst),
    //     .pc_in_if_id(pc_in_if_id),
    //     .pc4_in_if_id(pc4_in_if_id),
    //     .instruction_in_if_id(instruction_in_if_id),
    //     .pc_out_if_id(pc_out_if_id),
    //     .pc4_out_if_id(pc4_out_if_id),
    //     .instruction_out_if_id(instruction_out_if_id)
    // );



//stages
    IF_stage IF_stage_inst(
        .clk(clk),
        .rst(rst),

        .pcSel(pcSel),
        .branchAddress(branchAddress),

        .instruction_in_if_id(instruction_in_if_id),
        .PC_in_if_id(PC_in_if_id),
        .PC4_in_if_id(PC4_in_if_id)
    );

    //instatntiate ID stage
    ID_stage ID_stage_inst(
        .clk(clk),
        .rst(rst),

        .memRead_out_id_ex(memRead_out_id_ex),

        .memRead_out_ex_mem(memRead_out_ex_mem),
        .regWrite_out_ex_mem(regWrite_out_ex_mem),
        .wbMuxSel_out_ex_mem(wbMuxSel_out_ex_mem),
        
        .regWrite_out_mem_wb(regWrite_out_mem_wb),


        .PC_out_if_id(PC_out_if_id),
        .PC4_out_if_id(PC4_out_if_id),
        .instruction_out_if_id(instruction_out_if_id),

        .writeReg_out_id_ex(writeReg_out_id_ex),

        .aluOut_out_ex_mem(aluOut_out_ex_mem),
        .writeReg_out_ex_mem(writeReg_out_ex_mem),

        .writeReg_out_mem_wb(writeReg_out_mem_wb),
        .writeData_out_wb(writeData_out_wb),
        .memOut_out_mem_wb(memOut_out_mem_wb),

        .stall_if_id(stall_if_id),
        .flush_if_id(flush_if_id),
        .pcSel_out_id(pcSel_out_id),

        .stall_id_ex(stall_id_ex),
        .flush_id_ex(flush_id_ex),
        .ALUSrc1_in_id_ex(ALUSrc1_in_id_ex),
        .ALUSrc2_in_id_ex(ALUSrc2_in_id_ex),
        .ALUOp_in_id_ex(ALUOp_in_id_ex),

        .stall_ex_mem(stall_ex_mem),
        .flush_ex_mem(flush_ex_mem),
        .memRead_in_ex_mem(memRead_in_ex_mem),
        .memWrite_in_id_ex(memWrite_in_id_ex),

        .stall_mem_wb(stall_mem_wb),
        .flush_mem_wb(flush_mem_wb),
        .regWrite_in_ex_mem(regWrite_in_ex_mem),
        .wbMuxSel_in_ex_mem(wbMuxSel_in_ex_mem),

        .jmpAddress_out_id(jmpAddress_out_id),
        .writeData_in_id_ex(writeData_in_id_ex),
        .dataA_in_id_ex(dataA_in_id_ex),
        .dataB_in_id_ex(dataB_in_id_ex),
        .imm_in_id_ex(imm_in_id_ex),
        .func7_in_id_ex(func7_in_id_ex),
        .func3_in_id_ex(func3_in_id_ex),
        .writeReg_in_id_ex(writeReg_in_id_ex),
        .readReg1_in_id_ex(readReg1_in_id_ex),
        .readReg2_in_id_ex(readReg2_in_id_ex)
    );

//     EX_stage EX_stage_inst(
//         .clk(clk),
//         .rst(rst),
//         .pc_in_if_id(pc_in_if_id),
//         .pc4_in_if_id(pc4_in_if_id),
//         .instruction_in_if_id(instruction_in_if_id),
//         .pc_out_if_id(pc_out_if_id),
//         .pc4_out_if_id(pc4_out_if_id),
//         .instruction_out_if_id(instruction_out_if_id)
//     );

//     MEM_stage MEM_stage_inst(
//         .clk(clk),
//         .rst(rst),
//         .pc_in_if_id(pc_in_if_id),
//         .pc4_in_if_id(pc4_in_if_id),
//         .instruction_in_if_id(instruction_in_if_id),
//         .pc_out_if_id(pc_out_if_id),
//         .pc4_out_if_id(pc4_out_if_id),
//         .instruction_out_if_id(instruction_out_if_id)
//     );

//     WB_stage WB_stage_inst(
//         .clk(clk),
//         .rst(rst),
//         .pc_in_if_id(pc_in_if_id),
//         .pc4_in_if_id(pc4_in_if_id),
//         .instruction_in_if_id(instruction_in_if_id),
//         .pc_out_if_id(pc_out_if_id),
//         .pc4_out_if_id(pc4_out_if_id),
//         .instruction_out_if_id(instruction_out_if_id)
//     );

// //data forward unit
//     data_forward_unit data_forward_unit_inst(
//         .clk(clk),
//         .rst(rst),
//         .pc_in_if_id(pc_in_if_id),
//         .pc4_in_if_id(pc4_in_if_id),
//         .instruction_in_if_id(instruction_in_if_id),
//         .pc_out_if_id(pc_out_if_id),
//         .pc4_out_if_id(pc4_out_if_id),
//         .instruction_out_if_id(instruction_out_if_id)
//     );

// //hazard control unit
//     hazard_control_unit hazard_control_unit_inst(
//         .clk(clk),
//         .rst(rst),
//         .pc_in_if_id(pc_in_if_id),
//         .pc4_in_if_id(pc4_in_if_id),
//         .instruction_in_if_id(instruction_in_if_id),
//         .pc_out_if_id(pc_out_if_id),
//         .pc4_out_if_id(pc4_out_if_id),
//         .instruction_out_if_id(instruction_out_if_id)
//     );
    
endmodule