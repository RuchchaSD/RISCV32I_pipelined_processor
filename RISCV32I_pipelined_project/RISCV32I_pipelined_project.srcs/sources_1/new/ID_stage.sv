`timescale 1ns / 1ps
//control unit, branch comparator, register memory, immGen, forwarding unit branch and hazard detection unit are implemented in this module.





module ID_stage(
        input clk,
        input rst,
    
//inputs
    //control signals
        //IF stage

        //EX stage
        input logic memRead_out_id_ex,

        //MEM stage
        input logic memRead_out_ex_mem,
        input logic regWrite_out_ex_mem,
        input logic wbMuxSel_out_ex_mem,


        //WB stage
        input logic regWrite_out_mem_wb,

    //input data
        //IF stage
        input [31:0] PC_out_if_id,
        input [31:0] PC4_out_if_id,
        input [31:0] instruction_out_if_id,

        //EX stage
        input logic [4:0] writeReg_out_id_ex,

        //MEM stage
        input logic [31:0] aluOut_out_ex_mem,
        input logic [4:0] writeReg_out_ex_mem,

        //WB stage
        input logic [4:0] writeReg_out_mem_wb,
        input logic [31:0] writeData_out_wb,
        input logic [31:0] memOut_out_mem_wb,



//outputs
    //control signals
        //IF stage
        output logic stall_if_id,
        output logic flush_if_id,
        output logic pcSel_out_id,

        //EX stage
        output logic stall_id_ex,
        output logic flush_id_ex,
        output logic ALUSrc1_in_id_ex,
        output logic ALUSrc2_in_id_ex,
        output logic ALUOp_in_id_ex,



        //MEM stage
        output logic stall_ex_mem,
        output logic flush_ex_mem,
        output logic memRead_in_id_ex,
        output logic memWrite_in_id_ex,


        //WB stage
        output logic stall_mem_wb,
        output logic flush_mem_wb,
        output logic regWrite_in_id_ex,
        output logic wbMuxSel_in_id_ex,

    //output data
        //IF stage
        output logic [31:0] jmpAddress_out_id,

        //EX stage
        // output logic [31:0] pc_out_id_ex,
        // output logic [31:0] pc4_out_id_ex,
        // output logic [31:0] instruction_in_id_ex,
        output logic [31:0] writeData_in_id_ex,
        output logic [31:0] dataA_in_id_ex, // read data 1
        output logic [31:0] dataB_in_id_ex, // read data 2
        output logic [31:0] imm_in_id_ex,
        output logic [6:0] func7_in_id_ex,
        output logic [2:0] func3_in_id_ex,
        output logic [4:0] writeReg_in_id_ex,
        output logic [4:0] readReg1_in_id_ex,
        output logic [4:0] readReg2_in_id_ex

);
    
    logic [31:0] jalrAdd,brAdd;
    logic beq, blt,isJalr;
    
    register_memory reg_mem(clk, rst, regWrite_in_id_ex, writeReg_in_id_ex, readReg1_in_id_ex, readReg2_in_id_ex, writeData_in_id_ex, dataA_in_id_ex, dataB_in_id_ex);
    branch_comp bc(branch, dataA_in_id_ex, dataB_in_id_ex, beq, blt);
    imm_gen immg(instruction_out_if_id, imm_in_id_ex);
    
    
    //combinational
    always_comb begin
        readReg1_in_id_ex = instruction_out_if_id[19 : 15];
        readReg2_in_id_ex = instruction_out_if_id[24:20];
        writeReg_in_id_ex = instruction_out_if_id[11:7];
        
        jalrAdd = imm_in_id_ex + dataA_in_id_ex;
        brAdd = PC_out_if_id + imm_in_id_ex;
        
        //logic
        
        if(isJalr)
            jmpAddress_out_id = jalrAdd;
        else 
            jmpAddress_out_id = brAdd;
    end
    
    
    
endmodule
