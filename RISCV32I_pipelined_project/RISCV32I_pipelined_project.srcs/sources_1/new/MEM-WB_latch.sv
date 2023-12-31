`timescale 1ns / 1ps
module mem_wb_latch#(
        parameter DATA_WIDTH = 32
    )(
        input logic clk_mem_wb,
        input logic rst_mem_wb,
        input logic flush_mem_wb,
//INPUT
    //INPUT control signals
        //WB_control_signals
        input logic  regWrite_in_mem_wb,
        input logic  memToReg_in_mem_wb,

    //INPUT data
        //WB_data
        input logic [DATA_WIDTH-1:0]  memOut_in_mem_wb,        //data memory output
        input logic [DATA_WIDTH-1:0]  writeData_in_mem_wb,      //alu output
        input reg [4:0] dataRegWrite_in_mem_wb,    //write register number

//OUTPUT 
     //OUTPUT control signals
        //WB_control_signals
        output reg  regWrite_out_mem_wb,
        output reg  memToReg_out_mem_wb,
    //OUTPUT data
        //WB_data
        output reg [DATA_WIDTH-1:0]  memOut_out_mem_wb,
        output reg [DATA_WIDTH-1:0]  writeData_out_mem_wb,
        output reg [4:0] dataRegWrite_out_mem_wb
    );
    
    always_ff @(posedge clk_mem_wb) begin
    if (rst_mem_wb) begin
        // Reset all outputs to default values
        regWrite_out_mem_wb <= 0;
        memToReg_out_mem_wb <= 0;
        memOut_out_mem_wb <= 0;
        writeData_out_mem_wb <= 0;
        dataRegWrite_out_mem_wb <= 0;

    end
    else if (flush_mem_wb) begin
        // Reset control signals, but leave data intact
        regWrite_out_mem_wb <= 0;
        memToReg_out_mem_wb <= 0;


        // Data lines will get the next value
            memOut_out_mem_wb <= memOut_in_mem_wb;
            writeData_out_mem_wb <= writeData_in_mem_wb;
            dataRegWrite_out_mem_wb <= dataRegWrite_in_mem_wb;

    end
    else begin
        // Normal operation: Transfer input to output
        regWrite_out_mem_wb <= regWrite_in_mem_wb;
        memToReg_out_mem_wb <= memToReg_in_mem_wb;
        memOut_out_mem_wb <= memOut_in_mem_wb;
        writeData_out_mem_wb <= writeData_in_mem_wb;
        dataRegWrite_out_mem_wb <= dataRegWrite_in_mem_wb;
    end
end

    
    
endmodule