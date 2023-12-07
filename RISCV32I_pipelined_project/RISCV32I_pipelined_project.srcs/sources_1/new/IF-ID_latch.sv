`timescale 1ns / 1ps
module if_id_latch#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic clk_if_id,
        input logic rst_if_id,
        input logic flush_if_id
//INPUT
    //INPUT data
        //EXE_data
        
        //MEM_data

        //WB_data       


//OUTPUT 
    //OUTPUT data
        //EXE_data
        
        //MEM_data
        
        //WB_data 
        
    );
    
    always_ff @(posedge clk_if_id) begin
    if (rst_if_id | flush_if_id) begin
        // Reset all outputs to default values

    end
    else begin
        // Normal operation: Transfer input to output

    end
end

    
    
endmodule