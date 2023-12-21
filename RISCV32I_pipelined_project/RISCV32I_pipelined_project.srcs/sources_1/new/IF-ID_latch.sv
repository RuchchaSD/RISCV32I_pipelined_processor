`timescale 1ns / 1ps
module if_id_latch#(
        parameter WIDTH = 32
    )(
        input logic clk_if_id,
        input logic rst_if_id,
        input logic stall_if_id,
//INPUT
    //INPUT data
        //ID stage
        input logic [WIDTH-1:0] pc_in_if_id,
        input logic [WIDTH-1:0] pc4_in_if_id,
        input logic [WIDTH-1 :0] instruction_in_if_id,



//OUTPUT 
    //OUTPUT data
        //ID stage 
        output logic [WIDTH-1:0] pc_out_if_id,
        output logic [WIDTH-1:0] pc4_out_if_id,
        output logic [WIDTH:0] instruction_out_if_id
        
    );
    
    always_ff @(posedge clk_if_id or posedge rst_if_id) begin
    if (rst_if_id) begin
        // Reset all outputs to default values
        pc_out_if_id <= 0;
        pc4_out_if_id <= 0;
        instruction_out_if_id <= 0;

    end
    else if(!stall_if_id)begin
        // Normal operation: Transfer input to output
        pc_out_if_id <= pc_in_if_id;
        pc4_out_if_id <= pc4_in_if_id;
        instruction_out_if_id <= instruction_in_if_id;
    end
    // Else, when stall_if_id is asserted, do nothing (retain the current state)
end

    
    
endmodule