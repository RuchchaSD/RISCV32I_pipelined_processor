`timescale 1ns / 1ps
//Student ID - 200709K

// module branch_comp(
//     input logic branch,
//     input logic [31:0] dataA,
//     input logic [31:0] dataB,
//     output logic beq,
//     output logic blt
//     );
    
//     always_comb begin
//         if(branch)
//             blt = dataA < dataB;
//         else
//             blt = $signed(dataA) < $signed(dataB);
        
//         beq = dataA == dataB; 
//      end
    
// endmodule

module branch_comp(
    input logic branch,     //branch signal come from control unit
    input logic [2:0] Func3,
    input logic [1:0] brach_mux1,
    input logic [1:0] brach_mux2,
    input logic [31:0] ALUSrc1_in_id_ex,
    input logic [31:0] ALUSrc2_in_id_ex,
    input logic [31:0] aluOut_out_ex_mem,
    input logic [31:0] memOut_out_mem_wb,
    output logic branchTaken
    );

    logic [31:0] dataA;
    logic [31:0] dataB;

    always_comb 
        begin
        case({branch,Func3})
            4'b1000: branchTaken = (dataA == dataB); //beq
            4'b1001: branchTaken = (dataA != dataB); //bne
            4'b1100: branchTaken = ($signed(dataA) < $signed(dataB)); //blt
            4'b1101: branchTaken = ($signed(dataA) >= $signed(dataB)); //bge
            4'b1110: branchTaken = (dataA < dataB); //bltu
            4'b1111: branchTaken = (dataA >= dataB); //bgeu
            default: branchTaken = 1'b0;
        endcase
    end
    
    always_comb
        begin
        case(brach_mux1)
            2'b00: dataA = ALUSrc1_in_id_ex;
            2'b01: dataA = aluOut_out_ex_mem;
            2'b10: dataA = memOut_out_mem_wb;
            2'b11: dataA = 0;
            default: dataA = 0;
        endcase
    end

    always_comb
        begin
        case(brach_mux2)
            2'b00: dataB = ALUSrc2_in_id_ex;
            2'b01: dataB = aluOut_out_ex_mem;
            2'b10: dataB = memOut_out_mem_wb;
            2'b11: dataB = 0;
            default: dataB = 0;
        endcase
    end


    
endmodule