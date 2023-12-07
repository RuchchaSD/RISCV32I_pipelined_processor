`timescale 1ns / 1ps
module ex_mem_latch#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic clk_ex_mem,
        input logic rst_ex_mem,
        input logic flush_ex_mem,
//INPUT
    //INPUT control signals
        //MEM_control_signals
        input logic  controlMRead_in_ex_mem,
        input logic [2:0] controlMWrite_in_ex_mem,
        //WB_control_signals
        input logic  memToReg_in_ex_mem,
    //INPUT data
        //MEM_data
        input logic [ADDRESS_LENGTH - 1:0] aluOut_in_ex_mem,
        input logic [ADDRESS_LENGTH - 1:0] dataMWrite_in_ex_mem,
        //WB_data       
        input logic [ADDRESS_LENGTH - 1:0] dataRegWrite_in_ex_mem,

//OUTPUT 
     //OUTPUT control signals
        //MEM_control_signals
        input reg  controlMRead_out_ex_mem,
        input reg [2:0] controlMWrite_out_ex_mem,
        //WB_control_signals
        input reg  memToReg_out_ex_mem,
    //OUTPUT data
        //MEM_data
        input reg [ADDRESS_LENGTH - 1:0] aluOut_out_ex_mem,
        input reg [ADDRESS_LENGTH - 1:0] dataMWrite_out_ex_mem,
        //WB_data       
        input reg [ADDRESS_LENGTH - 1:0] dataRegWrite_out_ex_mem
        
    );
    
    always_ff @(posedge clk_ex_mem) begin
    if (rst_ex_mem) begin
        // Reset all outputs to default values
        controlMRead_out_ex_mem <= 0;
        controlMWrite_out_ex_mem <= 0;
        memToReg_out_ex_mem <= 0;
        aluOut_out_ex_mem <= 0;
        dataMWrite_out_ex_mem <= 0;
        dataRegWrite_out_ex_mem <= 0;
    end
    else if (flush_ex_mem) begin
        // Reset control signals, but leave data intact
        controlMRead_out_ex_mem <= 0;
        controlMWrite_out_ex_mem <= 0;
        memToReg_out_ex_mem <= 0;
        // Data lines will get the next value
         aluOut_out_ex_mem <= aluOut_out_ex_mem;
         dataMWrite_out_ex_mem <= dataMWrite_out_ex_mem;
         dataRegWrite_out_ex_mem <= dataRegWrite_out_ex_mem;
    end
    else begin
        // Normal operation: Transfer input to output
        controlMRead_out_ex_mem <= controlMRead_in_ex_mem;
        controlMWrite_out_ex_mem <= controlMWrite_in_ex_mem;
        memToReg_out_ex_mem <= memToReg_in_ex_mem;
        aluOut_out_ex_mem <= aluOut_in_ex_mem;
        dataMWrite_out_ex_mem <= dataMWrite_in_ex_mem;
        dataRegWrite_out_ex_mem <= dataRegWrite_in_ex_mem;
    end
end

    
    
endmodule