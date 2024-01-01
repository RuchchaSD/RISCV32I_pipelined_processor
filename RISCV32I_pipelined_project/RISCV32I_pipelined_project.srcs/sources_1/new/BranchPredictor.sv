`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.01.2024 10:23:16
// Design Name: 
// Module Name: BranchPredictor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//branch pc sel instruciton jump address inputoutput newpcsel, new branch address either the jump address or the branch address ,   // branch from id
module BranchPredictor(
    input logic clk,
    input logic [31:0] instruction, //instruction 
    input logic branch,
    input logic [1:0] pcSel,
    input logic [31:0] current_pc,
    input logic [31:0] jumpAddress,
    output logic flush,
    output logic [1:0] newPCSel,
    output logic [31:0] newAddress    //--->branch =0 jump jlr and pcsel different to 0 pc sel -> new pc sel
    );
    
    //logic [1:0] correct_pc_internal;
    logic [6:0] opcode;
    logic [31:0] imm;
    logic [31:0] branchAdd;
    logic [31:0] altPC;
    logic BrORJmp;
    logic branchOutcome;
    logic flag;
    
    typedef enum logic [1:0]{
        StronglyNotTaken = 2'b00,
        WeaklyNotTaken = 2'b01,
        WeaklyTaken = 2'b10,
        StronglyTaken = 2'b11
    } PredictionState;
    
    PredictionState currentState;
        
    //initial state
    initial begin
        currentState = WeaklyNotTaken;
    end 
    
    always_comb begin
        branchOutcome = (pcSel != 2'b00 & branch & flag || pcSel == 2'b00 & branch & !flag   ) ? 1: 0;
        opcode = instruction[6:0];
        imm = {instruction[31]? {20{1'b1}}:{20{1'b0}} , instruction[7], instruction[30:25],instruction[11:8],1'b0};
        branchAdd = current_pc + imm;
        
        //if the instruction is branch,jal,jalr
        BrORJmp = (opcode == 7'b1100011 || opcode == 7'b1100111 || opcode == 7'b1101111)? 1: 0;
    
        if (BrORJmp)begin
            if (opcode == 7'b1100011) begin //if a branch instruction
                case(currentState) //branch 0 newpcsel = pcsel branch 1 
                    StronglyNotTaken,WeaklyNotTaken: 
                          begin 
                            newPCSel = 2'b00; //should be pc sel pc+4 -00
                            altPC = branchAdd;
                            flag = 1'b0;
                          end
                    WeaklyTaken,StronglyTaken: 
                        begin 
                            newPCSel = 2'b01;
                            newAddress = branchAdd;
                            altPC = current_pc + 4;
                            flag = 1'b1;
                        end
                    default: newPCSel = 2'b00;
                  endcase
             end else begin
                newPCSel = 2'b01;
                newAddress = jumpAddress;
             end       
        end else begin
            newPCSel = 2'b00;
        end
    end
       
   always_ff @(negedge clk) begin //check the condition
        case (currentState)
            StronglyNotTaken: currentState <= (branchOutcome) ? WeaklyTaken : StronglyNotTaken; 
            WeaklyNotTaken: currentState <= (branchOutcome) ? WeaklyTaken : StronglyNotTaken;
            WeaklyTaken: currentState <= (branchOutcome) ? StronglyTaken : WeaklyNotTaken;
            StronglyTaken: currentState <= (branchOutcome) ? StronglyTaken : WeaklyTaken;
            default:currentState <= WeaklyNotTaken; 
        endcase
        if (!branchOutcome) begin // misprediction
            flush <= 1'b1;
            newAddress <= altPC;
            newPCSel <= 2'b00;
        end
    end

endmodule
