`timescale 1ns / 1ps

//This module is the top module of the pipeline and connects all the stages together. each stage is a module and each latch is a module.
//This module also contains the data_forward unit and hazard control unit.
//Each stage is connected to the next stage through a latch.


module RISCV32I_pipelined#(
        parameter ADDRESS_LENGTH = 32
    )(
    //inputs
    input logic clk,
    input logic rst,    
    //initiations
    logic [ADDRESS_LENGTH-1:0] pc_in_if_id, pc4_in_if_id,instruction_in_if_id, // outputs of if stage input to IF_ID latch
                               pc_out_if_id, pc4_out_if_id,instruction_out_if_id, //outputs of if_id latch
                               branchAddress, //IF stage input
    logic [1:0] pcSel,//control signal input to IF stage
    logic stall_if_id //control signal
    );

//IF stage
    wire  pcSel_out_id; //control signal
    wire [31:0] jmpAddress_out_id; //branch address
    wire [31:0]  PC_in_if_id, PC4_in_if_id;
    IF_stage IF_stage_inst(clk, rst, pcSel_out_id, jmpAddress_out_id, instruction_in_if_id, PC_in_if_id, PC4_in_if_id);

//if_id latch
    if_id_latch IF_ID_latch_inst(clk, rst, stall_if_id,  PC_in_if_id, PC4_in_if_id, instruction_in_if_id, pc_out_if_id,
     pc4_out_if_id, instruction_out_if_id);

    wire flush_if_id;
    wire [31:0] PC_out_if_id, pc4_out_if_id, instruction_out_if_id;
    wire stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex,stall_ex_mem, 
    flush_ex_mem, memRead_in_ex_mem, memWrite_in_id_ex,stall_mem_wb, flush_mem_wb, regWrite_in_ex_mem, wbMuxSel_in_ex_mem;
//ID stage
    wire [2:0] func3_in_id_ex;                                                   
    wire [3:0] ALUOp_in_id_ex;    //4 bits here                                               
    wire [4:0] writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex;          
    wire [6:0] func7_in_id_ex;                                                   
    wire [31:0] writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex;
    wire [4:0] writeReg_out_id_ex;
    
    ID_stage ID_stage_inst(clk, rst, memRead_out_ex_mem, regWrite_out_ex_mem, wbMuxSel_out_ex_mem, regWrite_out_mem_wb,
     PC_out_if_id, pc4_out_if_id, instruction_out_if_id, writeReg_out_id_ex, aluOut_out_ex_mem, writeReg_out_ex_mem, writeReg_out_mem_wb, 
     writeData_out_wb, memOut_out_mem_wb, 
     stall_if_id, flush_if_id, pcSel_out_id, stall_id_ex, flush_id_ex, ALUSrc1_in_id_ex, 
     ALUSrc2_in_id_ex, ALUOp_in_id_ex, //????that 4 bit value used here
     stall_ex_mem, flush_ex_mem, memRead_in_ex_mem,
     memWrite_in_id_ex, stall_mem_wb, flush_mem_wb, 
     regWrite_in_ex_mem, wbMuxSel_in_ex_mem, jmpAddress_out_id, writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex, imm_in_id_ex, 
     func7_in_id_ex, func3_in_id_ex, writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex);
    
    wire ALUSrc1_out_id_ex, ALUSrc2_out_id_ex,  memRead_out_id_ex, memWrite_out_id_ex, regWrite_out_id_ex, wbMuxSel_out_id_ex;
    wire [1:0] ALUOp_out_id_ex; //????this is 2 bit but this is assigned a 1 bit value in latch
    reg [1:0] PCSrc,ALUSrc1,ALUSrc2,ALUOp; //changed these to reg
    wire [2:0] func3_out_id_ex;
    reg [2:0] Func3;
    wire [6:0] func7_out_id_ex;
    reg [6:0] Func7;
    wire [4:0] readReg1_out_id_ex, readReg2_out_id_ex;
    wire [31:0] PC_out_id_ex, PC4_out_id_ex, dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex;
    reg [31:0] Result;
    
    id_ex_latch ID_EX_latch_inst(clk, rst, flush_id_ex, stall_id_ex, ALUSrc1_in_id_ex, ALUSrc2_in_id_ex, ALUOp_in_id_ex, //???that same 4 bit value used here but in latch its a 1 bit value
    memRead_in_ex_mem, memWrite_in_id_ex, regWrite_in_ex_mem, wbMuxSel_in_ex_mem, PC_in_if_id, PC4_in_if_id, dataA_in_id_ex, dataB_in_id_ex, 
    imm_in_id_ex, func7_in_id_ex, func3_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex, writeReg_in_id_ex,
    ALUSrc1_out_id_ex, ALUSrc2_out_id_ex, ALUOp_out_id_ex, memRead_out_id_ex, memWrite_out_id_ex, regWrite_out_id_ex, wbMuxSel_out_id_ex,
    PC_out_id_ex, PC4_out_id_ex,dataA_out_id_ex, dataB_out_id_ex, imm_out_id_ex, func7_out_id_ex, func3_out_id_ex, readReg1_out_id_ex, readReg2_out_id_ex, 
    writeReg_out_id_ex);

    //////************ you said it should be wire but when i searched it on google they say to make it reg
    reg[31:0] ID_EX_ReadData1,WB_Data,EX_MEM_Data,ID_EX_ReadData2,ID_EX_PC,ID_EX_Immediate;

    always_comb begin
        ID_EX_ReadData1 = dataA_out_id_ex;
        WB_Data = regWrite_out_wb; //can there be a WB data in id_ex stage is this a mistake ?
        EX_MEM_Data = aluOut_out_ex_mem;
        ID_EX_ReadData2 = dataB_out_id_ex;
        ID_EX_PC = PC_out_id_ex;
        ID_EX_Immediate = imm_out_id_ex;
        ALUSrc1 = ALUSrc1_out_id_ex;
        ALUSrc2 = ALUSrc2_out_id_ex;
        ALUOp = ALUOp_out_id_ex;
        Func7 = func7_out_id_ex;
        Func3 = func3_out_id_ex;
        Result = aluOut_in_ex_mem; //not only this but also the aluOut_out_ex_mem is also used above but declared below but for that there is no error
    end


//EX stage
    EX_stage EX_stage_inst(ID_EX_ReadData1,WB_Data,EX_MEM_Data,ID_EX_ReadData2,ID_EX_PC,ID_EX_Immediate,ALUSrc1,ALUSrc2,ALUOp,Func7,Func3,readReg1_out_id_ex,
    readReg2_out_id_ex,writeReg_out_ex_mem,writeReg_out_mem_wb,Result,dataMWrite_in_ex_mem);

    reg memRead_out_ex_mem, regWrite_in_ex_mem, wbMuxSel_out_ex_mem,controlMRead_in_ex_mem,memToReg_in_ex_mem;
    reg [2:0] controlMWrite_in_ex_mem; //made to reg
    wire [31:0] aluOut_in_ex_mem,dataMWrite_in_ex_mem;

//EXE-MEM latch

    always_comb begin
        controlMRead_in_ex_mem = memRead_out_id_ex;
        controlMWrite_in_ex_mem = memWrite_out_id_ex;
        memToReg_in_ex_mem = wbMuxSel_out_id_ex;
        dataRegWrite_in_ex_mem = writeReg_out_id_ex; //this dataRegWrite is not declared right?
        regWrite_in_ex_mem = regWrite_out_id_ex; // same with this

    end

    ex_mem_latch EX_MEM_latch_inst(clk, rst, flush_ex_mem, stall_ex_mem,
    controlMRead_in_ex_mem,controlMWrite_in_ex_mem,memToReg_in_ex_mem, regWrite_in_ex_mem, aluOut_in_ex_mem,dataMWrite_in_ex_mem,dataRegWrite_in_ex_mem,
    controlMRead_out_ex_mem,controlMWrite_out_ex_mem,memToReg_out_ex_mem, regWrite_out_ex_mem, aluOut_out_ex_mem,dataMWrite_out_ex_mem,dataRegWrite_out_ex_mem);

    wire controlMRead_out_ex_mem,memToReg_out_ex_mem, regWrite_out_ex_mem;
    wire [2:0] controlMWrite_out_ex_mem;
    wire [4:0] writeReg_out_ex_mem,dataRegWrite_out_ex_mem;
    wire [31:0] aluOut_out_ex_mem,dataMWrite_out_ex_mem;

    always_comb begin
        ExMem_Addr = aluOut_out_ex_mem;
        WriteDataMem_out_ex_mem = dataMWrite_out_ex_mem;
        MemRead_out_ex_mem = controlMRead_out_ex_mem;
        MemWrite_out_ex_mem = controlMWrite_out_ex_mem;
    end

//Mem stage

    reg MemRead_out_ex_mem,MemWrite_out_ex_mem, regWrite_in_mem_wb; //************Check the wire size of MemWrite_out_ex_mem signal,changed to reg   
    wire [4:0] dataRegWrite_in_mem_wb;                                                                                                               
    reg [31:0] ExMem_Addr,WriteDataMem_out_ex_mem;                                                                                                   
    wire [31:0] memOut_in_mem_wb;                                                                                                                    

    MEM_stage MEM_stage_inst(clk, ExMem_Addr,WriteDataMem_out_ex_mem,MemRead_out_ex_mem,MemWrite_out_ex_mem,memOut_in_mem_wb);
   
//MEM-WB latch
    always_comb begin
        writeData_in_mem_wb = memOut_in_mem_wb;
        memToReg_in_mem_wb = memToReg_out_ex_mem;
        regWrite_in_mem_wb = RegWrite_out_ex_mem;
        dataRegWrite_in_mem_wb = dataRegWrite_out_ex_mem;
    end

    // mem_wb_latch MEM_WB_latch_inst(clk_mem_wb, rst_mem_wb, flush_mem_wb, stall_mem_wb, writeData_in_mem_wb, memOut_in_mem_wb, 
    // regWrite_in_mem_wb, wbMuxSel_in_mem_wb, writeData_out_mem_wb, memOut_out_mem_wb, regWrite_out_mem_wb, wbMuxSel_out_mem_wb);

    mem_wb_latch MEM_WB_latch_inst(clk_mem_wb, rst_mem_wb, flush_mem_wb, regWrite_in_mem_wb, 
    memToReg_in_mem_wb, memOut_in_mem_wb, writeData_in_mem_wb,dataRegWrite_in_mem_wb, regWrite_out_mem_wb, 
    memToReg_out_mem_wb, memOut_out_mem_wb, writeData_out_mem_wb, dataRegWrite_out_mem_wb);

    wire  memToReg_in_mem_wb, regWrite_out_mem_wb, memToReg_out_mem_wb;
//    wire [1:0] ;
//    wire [2:0] ;
//    wire [3:0] ;
    wire [4:0] writeReg_out_mem_wb, dataRegWrite_out_mem_wb;
    wire [31:0] memOut_in_mem_wb, writeData_in_mem_wb, writeData_out_wb, memOut_out_mem_wb, writeData_out_mem_wb;

    always_comb begin
        wbMuxSel_out_mem_wb = memToReg_out_mem_wb;  //Signal to the mux in WB stage
        aluOut_out_mem_wb = writeData_out_mem_wb;
    end


// wb stage
    // WB_stage WB_stage_inst(clk, rst, writeData_in_mem_wb, memOut_in_mem_wb, regWrite_in_mem_wb, wbMuxSel_in_mem_wb, writeData_out_mem_wb, 
    // memOut_out_mem_wb, regWrite_out_mem_wb, wbMuxSel_out_mem_wb, writeData_out_wb, memOut_out_wb, regWrite_out_wb, wbMuxSel_out_wb);
    wire wbMuxSel_out_mem_wb ;      
                    
    wire [31:0] aluOut_out_mem_wb, writeData_out_wb;    WB_stage WB_stage_inst(clk, rst, wbMuxSel_out_mem_wb, aluOut_out_mem_wb, memOut_out_mem_wb, writeData_out_wb);
    




endmodule