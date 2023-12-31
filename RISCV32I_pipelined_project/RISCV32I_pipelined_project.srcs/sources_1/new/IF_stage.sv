`timescale 1ns / 1ps
module IF_stage#(
        parameter DATA_WIDTH = 32
)(
//inputs
    input clk,
    input logic rst,
    
    //inputs from id
    input logic [1:0] pcSel,
    input logic  [DATA_WIDTH-1:0] jmpAddress,
    
//outputs
    //outputs to if/id
    output logic [DATA_WIDTH-1:0] instruction_in_if_id,
    output logic [DATA_WIDTH-1:0] PC_in_if_id,
    output logic [DATA_WIDTH-1:0] PC4_in_if_id
    
    //outputs to otherplaces
);
        
    //initiations
    Instruction_memory instruction_in_if_id_memory_inst(
        .clk(clk),
        .rst(rst),
        .address(PC_in_if_id),
        .instruction_in_if_id(instruction_in_if_id)
        );
    
    
    //combinational blocks    
    always_comb begin 
        PC4_in_if_id = PC_in_if_id + 4;
    end
    
    //sequential
    always_ff @(negedge clk or posedge rst) begin
        if(rst) begin
            PC_in_if_id <= 0;
        end
        else begin
            if(pcSel == 2'b01)
                PC_in_if_id <= jmpAddress;
            else if(pcSel == 2'b10)
                PC_in_if_id <= PC_in_if_id;
            else 
                PC_in_if_id <= PC4_in_if_id;
        end
    end
endmodule
