`timescale 1ns / 1ps


// module data_memory#(
//     parameter DM_ADDRESS = 9 ,
//     parameter DATA_WIDTH = 32
//     )(
//     input logic clk,
//     input logic [DATA_WIDTH-1:0] ALUresult, //address comming in to the data memory  //addRW
//     input logic [DATA_WIDTH-1:0] WriteData, // data came to write on data memory     //dataW
//     input logic  MemRead,  //control signal to read data from data memory  //memRead
//     input logic  MemWrite,  //control signal to write data to data memory  //memWrite
//     output logic [DATA_WIDTH-1:0]  ReadData //data read out from data memory    //dataOut --> ReadData
//     );
    
     
//     logic [DATA_WIDTH-1:0] mem [(2**DM_ADDRESS)-1:0];   //initiate the data memeory  //mem=DMEM
    
    
//  always @(posedge clk) begin
//        if (MemWrite)    //data write into the data memory
//             mem[ALUresult] = WriteData;
//        if (MemRead)     //data read from the data memory
//             ReadData = mem[ALUresult];
//  end   
    
// endmodule

module data_memory#(
    parameter ADDRESS_LENGTH = 6, 
    parameter DATA_WIDTH = 32
)(
    input clk,
    input logic [DATA_WIDTH - 1:0] ALUresult,
    input logic [DATA_WIDTH - 1:0] WriteData,
    input logic [2:0] MemRead, // active high
    input logic [2:0] MemWrite, // 1 = sw, 2 = sh 3 = sb 
    output logic[DATA_WIDTH - 1:0] ReadData
    );
    
//    logic  [DATA_WIDTH - 1:0] DMEM[ 2**(ADDRESS_LENGTH-2) :0];
      logic [7 : 0] DMEM[2**ADDRESS_LENGTH - 1 : 0];    

      logic [DATA_WIDTH-1 :0]dataOut;

      logic [ADDRESS_LENGTH-1 :0] addRW;
      
      assign addRW = ALUresult[ADDRESS_LENGTH-1 :0];
      
initial begin
    for(int i = 0; i < 2**ADDRESS_LENGTH; i++)
        DMEM[i] = 0;
        end

assign dataOut[31:24] = DMEM[addRW];
assign dataOut[23:16] = DMEM[addRW+1];
assign dataOut[15:8] = DMEM[addRW+2];
assign dataOut[7:0] = DMEM[addRW+3];

    always_ff @(posedge clk)       //might be changed to negedge clk
//        if(MemWrite)
//            DMEM[ALUresult] <= WriteData ;
        case(MemWrite)
            1   :
                begin
                    DMEM[addRW]     <= WriteData[31 : 24];
                    DMEM[addRW + 1] <= WriteData[23 :16];
                    DMEM[addRW + 2] <= WriteData[15 : 8];
                    DMEM[addRW + 3] <= WriteData[7  : 0];
                end
            2   :
                begin
                    DMEM[addRW]     <= WriteData[15 : 8];
                    DMEM[addRW + 1] <= WriteData[7  : 0];
                end
            3   :
                begin
                    DMEM[addRW] <= WriteData[7:0];
                end
            4   :
                begin
                    DMEM[addRW]     <= WriteData[31 : 24];
                end
            5   :
                begin
                    DMEM[addRW]     <= WriteData[31 : 24];
                    DMEM[addRW + 1] <= WriteData[23 :16];
                end
            6   :
                begin
                    DMEM[addRW]     <= WriteData[31 : 24];
                    DMEM[addRW + 1] <= WriteData[23 :16];
                    DMEM[addRW + 2] <= WriteData[15 : 8];
                end
        endcase

//      always_comb begin
//        if (MemRead && ALUresult < 2**(ADDRESS_LENGTH-2)) begin
//            dataOut = DMEM[ALUresult];
//        end
//        else begin
//            // Default value when read is not enabled or address is out of bounds
//            dataOut = '0;
//        end
//    end

    always_comb 
        case(MemRead)
            //3'b000: ReadData = dataOut[31:24];
            3'b010  : // lw
                ReadData = dataOut;
            3'b001  : // lh
                ReadData = {dataOut[31] ? {16{dataOut[31]}} : 16'b0, dataOut[31:16] };
            3'b000  : // lb
                ReadData = {dataOut[31] ? {24{dataOut[31]}} : 24'b0, dataOut[31:24] };
            3'b101  : // lhu
                ReadData = {16'b0, dataOut[31:16] };
            3'b100  : // lbu
                ReadData = {24'b0, dataOut[31:24] };
            // 3'b110  : //SB
            //     ReadData_h = dataOut[15:0];
            // 3'b111  : //SH
            //     ReadData_b = dataOut[7:0];
            default :
                ReadData = 0;
        endcase

endmodule