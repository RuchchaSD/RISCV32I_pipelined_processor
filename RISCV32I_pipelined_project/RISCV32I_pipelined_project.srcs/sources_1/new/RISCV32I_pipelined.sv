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
    //initiations
    );


    logic [ADDRESS_LENGTH-1:0] pc_in_if_id,instruction_in_if_id, pc4_out_if_id,instruction_out_if_id;
    // logic [1:0] pcSel;
    logic stall_if_id;

//IF stage ports
    logic flush_if_id;
    logic [31:0] PC_out_if_id;
    logic stall_id_ex, flush_id_ex,stall_ex_mem, 
    flush_ex_mem, memRead_in_ex_mem, stall_mem_wb, flush_mem_wb, wbMuxSel_in_ex_mem;

    logic [1:0] pcSel_out_id,ALUSrc1_out_id_ex, ALUSrc2_out_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex,ALUSrc1,ALUSrc2;
    logic [31:0] jmpAddress_out_id;
    logic [31:0]  PC_in_if_id, PC4_in_if_id;
 
    
    
          

//ID Stage initiations
    logic [31:0] PC_in_id_ex,PC4_in_id_ex;
    logic [2:0] func3_in_id_ex;                                                   
    logic [3:0] ALUOp_in_id_ex;                                            
    logic [4:0] writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex;          
    logic [6:0] func7_in_id_ex;                                                   
    logic [31:0] writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex;
    logic [4:0] writeReg_out_id_ex;

    logic     regWrite_out_id_ex, wbMuxSel_out_id_ex,regWrite_in_id_ex,wbMuxSel_in_id_ex;
    logic [3:0] ALUOp_out_id_ex;
    logic [3:0] PCSrc,ALUOp;
    logic [2:0] memWrite_out_id_ex,memWrite_in_id_ex,memRead_out_id_ex,func3_out_id_ex,memRead_in_id_ex;
    logic [2:0] Func3;
    logic [6:0] func7_out_id_ex;
    logic [6:0] Func7;
    logic [4:0] readReg1_out_id_ex, readReg2_out_id_ex,writeReg_in_ex_mem;
    logic [31:0] PC_out_id_ex, PC4_out_id_ex, dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex;
    logic [31:0] Result;

    logic[31:0] ID_EX_ReadData1,WB_Data,EX_MEM_Data,ID_EX_ReadData2,ID_EX_PC,ID_EX_Immediate;


//Ex stage declerations
    logic  regWrite_in_ex_mem, wbMuxSel_out_ex_mem,memToReg_in_ex_mem;
    logic [2:0] MemRead_out_ex_mem,controlMWrite_in_ex_mem,controlMRead_in_ex_mem;
    logic [31:0] aluOut_in_ex_mem,dataMWrite_in_ex_mem;
    
    logic memToReg_out_ex_mem, regWrite_out_ex_mem;
    logic [2:0] controlMRead_out_ex_mem,controlMWrite_out_ex_mem;
    logic [4:0] writeReg_out_ex_mem,writeReg_out_mem_wb;
    logic [31:0] aluOut_out_ex_mem,dataMWrite_out_ex_mem;
    
//MemStage declerations
    logic  regWrite_in_mem_wb;
    logic [2 : 0] MemWrite_out_ex_mem;  
    logic [4:0] writeReg_in_mem_wb;                                                                                                               
    logic [31:0] ExMem_Addr,WriteDataMem_out_ex_mem;                                                                                                   
    logic [31:0] memOut_in_mem_wb;      
    
    logic  memToReg_in_mem_wb, regWrite_out_mem_wb, memToReg_out_mem_wb;
    logic [31:0]  writeData_in_mem_wb, memOut_out_mem_wb, writeData_out_mem_wb;

//Wbstage ports
    logic wbMuxSel_out_mem_wb ;              
    logic [31:0] aluOut_out_mem_wb, writeData_out_wb; 

//If stage 
    IF_stage IF_stage_inst(clk, rst, pcSel_out_id, jmpAddress_out_id, instruction_in_if_id, PC_in_if_id, PC4_in_if_id);

//if_id latch
    if_id_latch IF_ID_latch_inst(clk, flush_if_id, stall_if_id,  PC_in_if_id, PC4_in_if_id, instruction_in_if_id, PC_out_if_id,
     pc4_out_if_id, instruction_out_if_id);



//ID stage
    ID_stage ID_stage_inst(clk, rst,memRead_out_id_ex, MemRead_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_ex_mem, regWrite_out_mem_wb,wbMuxSel_out_mem_wb,
     PC_out_if_id, pc4_out_if_id, instruction_out_if_id, writeReg_out_id_ex, aluOut_out_ex_mem, writeReg_out_ex_mem, writeReg_out_mem_wb, 
     writeData_out_wb, memOut_out_mem_wb, 
     stall_if_id, flush_if_id, pcSel_out_id, stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex, 
     ALUSrc2_in_id_ex, ALUOp_in_id_ex,
     stall_ex_mem, flush_ex_mem, memRead_in_id_ex,
     memWrite_in_id_ex, stall_mem_wb, flush_mem_wb, 
     regWrite_in_id_ex, wbMuxSel_in_id_ex, jmpAddress_out_id, writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex, 
     func7_in_id_ex, func3_in_id_ex, writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex);



    assign  PC_in_id_ex = PC_out_if_id;
    assign  PC4_in_id_ex = pc4_out_if_id;

//ID-EX latch
    id_ex_latch ID_EX_latch_inst(clk, rst, flush_id_ex, stall_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex, ALUOp_in_id_ex,
    memRead_in_id_ex, memWrite_in_id_ex, regWrite_in_id_ex, wbMuxSel_in_id_ex, PC_in_id_ex, PC4_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, 
    imm_in_id_ex, func7_in_id_ex, func3_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex, writeReg_in_id_ex,
    ALUSrc1_out_id_ex, ALUSrc2_out_id_ex, ALUOp_out_id_ex, memRead_out_id_ex, memWrite_out_id_ex, regWrite_out_id_ex, wbMuxSel_out_id_ex,
    PC_out_id_ex, PC4_out_id_ex,dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex, func7_out_id_ex, func3_out_id_ex, readReg1_out_id_ex, readReg2_out_id_ex, 
    writeReg_out_id_ex);

    

    always_comb begin
        ID_EX_ReadData1 = dataA_out_id_ex;
        WB_Data = writeData_out_wb; 
        EX_MEM_Data = aluOut_out_ex_mem;
        ID_EX_ReadData2 = dataB_out_id_ex;
        ID_EX_PC = PC_out_id_ex;
        ID_EX_Immediate = imm_out_id_ex;
        ALUSrc1 = ALUSrc1_out_id_ex;
        ALUSrc2 = ALUSrc2_out_id_ex;
        ALUOp = ALUOp_out_id_ex;
        Func7 = func7_out_id_ex;
        Func3 = func3_out_id_ex;
        aluOut_in_ex_mem = Result ;
    end

//EX stage
    EX_stage EX_stage_inst(ID_EX_ReadData1,WB_Data,EX_MEM_Data,ID_EX_ReadData2,ID_EX_PC,ID_EX_Immediate,ALUSrc1,ALUSrc2,ALUOp,Func7,Func3,readReg1_out_id_ex,
    readReg2_out_id_ex,writeReg_out_ex_mem,writeReg_out_mem_wb,Result,dataMWrite_in_ex_mem);

//EXE-MEM latch

    always_comb begin
        controlMRead_in_ex_mem = memRead_out_id_ex;
        controlMWrite_in_ex_mem = memWrite_out_id_ex;
        memToReg_in_ex_mem = wbMuxSel_out_id_ex;
        writeReg_in_ex_mem = writeReg_out_id_ex; 
        regWrite_in_ex_mem = regWrite_out_id_ex;
    end

    ex_mem_latch EX_MEM_latch_inst(clk, rst, flush_ex_mem, stall_ex_mem,
    controlMRead_in_ex_mem,controlMWrite_in_ex_mem,memToReg_in_ex_mem, regWrite_in_ex_mem, aluOut_in_ex_mem,dataMWrite_in_ex_mem,writeReg_in_ex_mem,
    controlMRead_out_ex_mem,controlMWrite_out_ex_mem,memToReg_out_ex_mem, regWrite_out_ex_mem, aluOut_out_ex_mem,dataMWrite_out_ex_mem,writeReg_out_ex_mem);

    always_comb begin
        ExMem_Addr = aluOut_out_ex_mem;
        WriteDataMem_out_ex_mem = dataMWrite_out_ex_mem;
        MemRead_out_ex_mem = controlMRead_out_ex_mem;
        MemWrite_out_ex_mem = controlMWrite_out_ex_mem;
    end

//Mem stage

    MEM_stage MEM_stage_inst(clk, ExMem_Addr,WriteDataMem_out_ex_mem,MemRead_out_ex_mem,MemWrite_out_ex_mem,memOut_in_mem_wb);
   
//MEM-WB latch
    always_comb begin
        writeData_in_mem_wb = aluOut_out_ex_mem;
        memToReg_in_mem_wb = memToReg_out_ex_mem;
        regWrite_in_mem_wb = regWrite_out_ex_mem;
        writeReg_in_mem_wb = writeReg_out_ex_mem;
    end

    mem_wb_latch MEM_WB_latch_inst(clk, rst, flush_mem_wb, regWrite_in_mem_wb, 
    memToReg_in_mem_wb, memOut_in_mem_wb, writeData_in_mem_wb,writeReg_in_mem_wb, regWrite_out_mem_wb, 
    memToReg_out_mem_wb, memOut_out_mem_wb, writeData_out_mem_wb, writeReg_out_mem_wb);

    always_comb begin
        wbMuxSel_out_mem_wb = memToReg_out_mem_wb;
        aluOut_out_mem_wb = writeData_out_mem_wb;
    end

// wb stage
    WB_stage WB_stage_inst(clk, rst, wbMuxSel_out_mem_wb, aluOut_out_mem_wb, memOut_out_mem_wb, writeData_out_wb);


endmodule