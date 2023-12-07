`timescale 1ns / 1ps
module id_exe_latch#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic clk_id_exe,
        input logic rst_id_exe,
        input logic flush_id_exe
//INPUT
    //INPUT control signals
        //EXE_control_signals
        
        //MEM_control_signals

        //WB_control_signals

    //INPUT data
        //EXE_data
        
        //MEM_data

        //WB_data       


//OUTPUT 
     //OUTPUT control signals
        //EXE_control_signals
        
        //MEM_control_signals

        //WB_control_signals
    //OUTPUT data
        //EXE_data
        
        //MEM_data
        
        //WB_data 
        
    );
    
    always_ff @(posedge clk_id_exe) begin
    if (rst_id_exe) begin
        // Reset all outputs to default values

    end
    else if (flush_id_exe) begin
        // Reset control signals, but leave data intact


        // Data lines will get the next value

    end
    else begin
        // Normal operation: Transfer input to output

    end
end

    
    
endmodule