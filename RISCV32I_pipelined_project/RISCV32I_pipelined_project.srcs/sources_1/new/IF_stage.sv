`timescale 1ns / 1ps
module IF_stage#(
        parameter DATA_WIDTH = 32
)(
//inputs
    input clk,
    input logic rst,
    
    //inputs from id
    input logic flush_out_id,
    input logic branch_out_id,
    input logic [1:0] pcSel_out_id,
    input logic  [DATA_WIDTH-1:0] jmpAddress_out_id,
    
//outputs
    //outputs to if/id
    output logic flush_in_if_id,
    output logic [DATA_WIDTH-1:0] instruction_in_if_id,
    output logic [DATA_WIDTH-1:0] PC_in_if_id,
    output logic [DATA_WIDTH-1:0] PC4_in_if_id
    
    //outputs to otherplaces
);

    logic [1:0] pcSel;
    logic [DATA_WIDTH-1:0] jmpAddress;

        
    //initiations
    Instruction_memory instruction_memory_inst(
        .clk(clk),
        .rst(rst),
        .fullAddress(PC_in_if_id),
        .instruction(instruction_in_if_id)
        );
    
    
    //combinational blocks    
    always_comb begin 
        PC4_in_if_id = PC_in_if_id + 4;
    end
    
    //sequential
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            PC_in_if_id <= 0;
        end
        else begin
            if(pcSel == 2'b01)
                PC_in_if_id <= jmpAddress;// jump address
            else if(pcSel == 2'b10)
                PC_in_if_id <= PC_in_if_id; //stall
            else 
                PC_in_if_id <= PC4_in_if_id; // else PC <= PC + 4
        end
    end

    BranchPredictor branchPredictor_inst(
        .clk(clk),
        .rst(rst),
        .instruction(instruction_in_if_id),
        .branch(branch_out_id),//get from id
        .pcSel(pcSel_out_id),
        .current_pc4(PC4_in_if_id),
        .jumpAddress(jmpAddress_out_id),
        .flush_if(flush_out_id),
        .flush(flush_in_if_id),
        .newPCSel(pcSel),
        .newAddress(jmpAddress)
        );



endmodule
