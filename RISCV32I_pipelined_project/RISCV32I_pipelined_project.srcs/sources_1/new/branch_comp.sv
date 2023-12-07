`timescale 1ns / 1ps
//Student ID - 200709K

module branch_comp(
    input logic branch,
    input logic [31:0] dataA,
    input logic [31:0] dataB,
    output logic beq,
    output logic blt
    );
    
    always_comb begin
        if(branch)
            blt = dataA < dataB;
        else
            blt = $signed(dataA) < $signed(dataB);
        
        beq = dataA == dataB; 
     end
    
endmodule