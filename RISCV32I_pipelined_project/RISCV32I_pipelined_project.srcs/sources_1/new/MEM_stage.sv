`timescale 1ns / 1ps


module MEM_stage#(
    // parameter DM_ADDRESS = 9 ,
    parameter DATA_WIDTH = 32
    )(
    //inputs for data memory
    input logic clk,
    input logic [DATA_WIDTH-1:0] ExMem_Addr,
    input logic [DATA_WIDTH-1:0] WriteDataMem_out_ex_mem,
    input logic [2:0] MemRead_out_ex_mem,
    input logic [2:0] MemWrite_out_ex_mem,
    //outputs of ExMem latch
//    input logic ExMem_Inst,
//    input logic ExMem_WB,
    
    //outputs of data memory 
    output logic [DATA_WIDTH-1:0]  memOut_in_mem_wb
    //inputs for MemWb latch
//    output logic MemWb_Inst,
//    output logic MemWb_WB
    );
    
    
    data_memory dataMem(clk,ExMem_Addr,WriteDataMem_out_ex_mem,MemRead_out_ex_mem,MemWrite_out_ex_mem,memOut_in_mem_wb);
    
endmodule