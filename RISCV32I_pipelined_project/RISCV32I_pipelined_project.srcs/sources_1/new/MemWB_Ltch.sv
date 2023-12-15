`timescale 1ns / 1ps

module My_Mem_Wb_Ltc(
    input logic clk,
    input logic enable,
    input logic ExMemAddr,
    input logic ExMemInst,
    input logic ExMemWB,
    input logic ReadData, //(MemWbRd)
    output logic MemWbAddr,
    output logic MemWbInst,
    output logic MemWbWB,
    output logic MemWbRd
    );
    
    always @(posedge clk)begin
//    if(enable)begin
            MemWbAddr = ExMemAddr;
            MemWbInst = ExMemInst;
            MemWbWB = ExMemWB;
            MemWbRd = ReadData;
//        end
    end
    
endmodule
