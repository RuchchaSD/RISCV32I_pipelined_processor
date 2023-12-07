`timescale 1ns / 1ps
module mem_wb_latch#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic clk_mem_wb,
        input logic rst_mem_wb,
        input logic flush_mem_wb
//INPUT
    //INPUT control signals
        //WB_control_signals

    //INPUT data
        //WB_data       


//OUTPUT 
     //OUTPUT control signals
        //WB_control_signals
    //OUTPUT data
        //WB_data 
        
    );
    
    always_ff @(posedge clk_mem_wb) begin
    if (rst_mem_wb) begin
        // Reset all outputs to default values

    end
    else if (flush_mem_wb) begin
        // Reset control signals, but leave data intact


        // Data lines will get the next value

    end
    else begin
        // Normal operation: Transfer input to output

    end
end

    
    
endmodule