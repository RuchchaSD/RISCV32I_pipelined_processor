`timescale 1ns / 1ps
//control unit, branch comparator, register memory, immGen, forwarding unit branch and hazard detection unit are implemented in this module.





module ID_stage(
        input clk,
        input rst,
    
//inputs
    //control signals
        //IF stage

        //EX stage
        input logic [2:0] memRead_out_id_ex,

        //MEM stage
        input logic [2:0] memRead_out_ex_mem,
        input logic regWrite_out_ex_mem,
        input logic wbMuxSel_out_ex_mem,


        //WB stage
        input logic regWrite_out_mem_wb,wbMuxSel_out_mem_wb,

    //input data
        //IF stage
        input [31:0] PC_out_if_id,
        input [31:0] PC4_out_if_id,
        input [31:0] instruction_out_if_id,//

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
        output logic [1:0] pcSel_out_id,

        //EX stage
        output logic stall_id_ex,
        output logic flush_id_ex,
        output logic [1:0] ALUSrc1_in_id_ex,
        output logic [1:0] ALUSrc2_in_id_ex,
        output logic [3:0] ALUOp_in_id_ex,



        //MEM stage
        output logic stall_ex_mem,
        output logic flush_ex_mem,
        output logic [2:0] memRead_in_id_ex,
        output logic [2:0] memWrite_in_id_ex,


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
    logic beq, blt,isJalr,branch,stall,branchTaken,Id_Flush,If_Flush,Jump;
    logic [1:0] brach_mux1, brach_mux2;
    
    register_memory reg_mem(clk, rst, regWrite_out_mem_wb, writeReg_out_mem_wb, readReg1_in_id_ex,readReg2_in_id_ex,
      writeData_out_wb,dataA_in_id_ex,dataB_in_id_ex);
    
    imm_gen immg(instruction_out_if_id, imm_in_id_ex);
    control_unit cu_inst(clk,rst,instruction_out_if_id,ALUOp_in_id_ex,ALUSrc1_in_id_ex,ALUSrc2_in_id_ex, memRead_in_id_ex,regWrite_in_id_ex,
    memWrite_in_id_ex,wbMuxSel_in_id_ex,branch,
                                                    isJalr,flush_ex_mem,Id_Flush,flush_if_id,Jump);
    
    hazard_control_unit hcu_inst(memRead_out_id_ex, memRead_out_ex_mem, readReg1_in_id_ex, readReg2_in_id_ex, writeReg_out_id_ex, writeReg_out_ex_mem, stall);

    branch_data_forward bdf_inst(regWrite_out_ex_mem, wbMuxSel_out_ex_mem, regWrite_out_mem_wb, wbMuxSel_out_mem_wb, 
    readReg1_in_id_ex, readReg2_in_id_ex, writeReg_out_ex_mem, writeReg_out_mem_wb, brach_mux1, brach_mux2);
    branch_comp bc(branch, func3_in_id_ex, brach_mux1, brach_mux2, dataA_in_id_ex, dataB_in_id_ex, aluOut_out_ex_mem, memOut_out_mem_wb, branchTaken);

// branch data forward 
    
    
    //combinational
    always_comb begin
        readReg1_in_id_ex = instruction_out_if_id[19:15];
        readReg2_in_id_ex = instruction_out_if_id[24:20];
        writeReg_in_id_ex = instruction_out_if_id[11:7];
        
        jalrAdd = imm_in_id_ex + dataA_in_id_ex;
        brAdd = PC_out_if_id + imm_in_id_ex;
        
        //logic for calculating jump address
        
        if(isJalr)
            jmpAddress_out_id = jalrAdd;
        else 
            jmpAddress_out_id = brAdd;// for jal and branch
    end



//PC select logic
    always_comb begin
        if(branchTaken || Jump )//isJal || isJalr || branchTaken)
            pcSel_out_id = 2'b01;
        else if(stall)
            pcSel_out_id = 2'b10;
        else
            pcSel_out_id = 2'b00;
    end


    // assign pcSel_out_id = 0; // change when implementing branch and when stall is implemented

    //stall and flush flush logic change after implementing units
    always_comb begin
        stall_if_id = stall;
        // flush_if_id = 0;// no use
        stall_id_ex = 0;//no use
        // flush_id_ex = stall || Id_Flush; // another signals comes here from control unit, stall || flush_id 
        stall_ex_mem = 0;//no use
        // flush_ex_mem = 0;//signal comes from control unit flush_ex
        stall_mem_wb = 0;//no use
        flush_mem_wb = 0;//no use

        if(stall || Id_Flush)
            flush_id_ex = 1;
        else
            flush_id_ex = 0;
    end



    
    
    
    
endmodule
