`timescale 1ns / 1ps
module IF_stage#(
        parameter DATA_WIDTH = 32
)(
//inputs
    input clk,
    input logic rst,
    
    //inputs from mem/wb
    input logic [1:0] pcSel,
    input logic  [DATA_WIDTH-1:0] branchAddress,
    
//outputs
    //outputs to if/id
    output logic [DATA_WIDTH-1:0] instruction,
    output logic [DATA_WIDTH-1:0] nextPC,
    output logic [DATA_WIDTH-1:0] PC
    
    //outputs to otherplaces
);
        
    //initiations
    Instruction_memory instruction_memory_inst(
        .clk(clk),
        .rst(rst),
        .address(PC),
        .instruction(instruction)
        );
    
    
    //combinational blocks    
    always_comb begin 
        nextPC = PC + 4;
    end
    
    //sequential
    always_ff @(negedge clk or posedge rst) begin
        if(rst) begin
            PC <= 0;
        end
        else begin
            if(pcSel == 2'b01)
                PC <= branchAddress;
            else if(pcSel == 2'b10)
                PC <= PC;
            else 
                PC <= nextPC;
        end
    end
endmodule
