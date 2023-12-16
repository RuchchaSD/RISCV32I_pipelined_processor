`timescale 1ns / 1ps


module data_memory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_WIDTH = 32
    )(
    input logic clk,
    input logic [DATA_WIDTH-1:0] ALUresult, //address comming in to the data memory
    input logic [DATA_WIDTH-1:0] WriteData, // data came to write on data memory
    input logic  MemRead,  //control signal to read data from data memory
    input logic  MemWrite,  //control signal to write data to data memory
    output logic [DATA_WIDTH-1:0]  ReadData //data read out from data memory
    );
    
     
    logic [DATA_WIDTH-1:0] mem [(2**DM_ADDRESS)-1:0];   //initiate the data memeory
    
    
 always @(posedge clk) begin
       if (MemWrite)    //data write into the data memory
            mem[ALUresult] = WriteData;
       if (MemRead)     //data read from the data memory
            ReadData = mem[ALUresult];
 end   
    
endmodule