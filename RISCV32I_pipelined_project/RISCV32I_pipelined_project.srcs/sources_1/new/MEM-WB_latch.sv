`timescale 1ns / 1ps
module mem_wb_latch#(
        parameter ADDRESS_LENGTH = 32,
        parameter INSTR_LENGTH = 5
    )(
        input logic clk_mem_wb,
        input logic rst_mem_wb,
        input logic flush_mem_wb,
//INPUT
    //INPUT control signals
        //WB_control_signals
    input logic MemToReg_in_mem_wb,
    input logic RegWrite_in_mem_wb,
    //INPUT data
        //WB_data
        input logic [ADDRESS_LENGTH-1:0] ReadData_in_mem_wb,
        input logic [ADDRESS_LENGTH-1:0]ALUresult_in_mem_wb,
        input logic [INSTR_LENGTH-1:0] Inst7_11_in_mem_wb,       


//OUTPUT 
     //OUTPUT control signals
        //WB_control_signals
    output logic MemToReg_out_mem_wb,
    output logic RegWrite_out_mem_wb,
    //OUTPUT data
        //WB_data         
        output reg [ADDRESS_LENGTH-1:0]ReadData_out_mem_wb,
        output reg [ADDRESS_LENGTH-1:0]ALUresult_out_mem_wb,
        output reg [INSTR_LENGTH-1:0]Inst7_11_out_mem_wb
    
        
    );
    
    always_ff @(posedge clk_mem_wb) begin
    if (rst_mem_wb) begin
        // Reset all outputs to default values
        MemToReg_out_mem_wb <=0;
        RegWrite_out_mem_wb <=0;
        ReadData_out_mem_wb <=0;
        ALUresult_out_mem_wb <=0;
        Inst7_11_out_mem_wb <=0;

    end
    else if (flush_mem_wb) begin
        // Reset control signals, but leave data intact
        MemToReg_out_mem_wb <=0;
        RegWrite_out_mem_wb <=0;

        // Data lines will get the next value
        ReadData_out_mem_wb <= ReadData_in_mem_wb;
        ALUresult_out_mem_wb <= ALUresult_in_mem_wb;
        Inst7_11_out_mem_wb <= Inst7_11_in_mem_wb;

    end
    else begin
        // Normal operation: Transfer input to output
        MemToReg_out_mem_wb <= MemToReg_in_mem_wb;
        RegWrite_out_mem_wb <= RegWrite_in_mem_wb;
        ReadData_out_mem_wb <= ReadData_in_mem_wb;
        ALUresult_out_mem_wb <= ALUresult_in_mem_wb;
        Inst7_11_out_mem_wb <= Inst7_11_in_mem_wb;

    end
end

    
    
endmodule