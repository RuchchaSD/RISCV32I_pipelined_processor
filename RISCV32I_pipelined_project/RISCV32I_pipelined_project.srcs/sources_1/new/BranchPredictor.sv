// `timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 01.01.2024 10:23:16
// // Design Name: 
// // Module Name: BranchPredictor
// // Project Name: 
// // Target Devices: 
// // Tool Versions: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Revision:
// // Revision 0.01 - File Created
// // Additional Comments:
// // 
// //////////////////////////////////////////////////////////////////////////////////

// //branch pc sel instruciton jump address inputoutput newpcsel, new branch address either the jump address or the branch address ,   // branch from id
// module BranchPredictor(
//     input logic clk,
//     input logic rst,
//     input logic [31:0] instruction, //instruction 
//     input logic branch,
//     input logic [1:0] pcSel,
//     input logic [31:0] current_pc4,
//     input logic [31:0] jumpAddress,
//     input logic flush_out_id,





//     output logic flush,
//     output logic [1:0] newPCSel,
//     output logic [31:0] newAddress    //--->branch =0 jump jlr and pcsel different to 0 pc sel -> new pc sel
//     );
    
//     //logic [1:0] correct_pc_internal;
//     logic [6:0] opcode; // opcode of the instruction
//     logic [31:0] imm; // branch type immidiate
//     logic [31:0] branchAdd; // address if a branch is taken
//     logic [31:0] altPC; // alternative pc
//     logic currentBranch,allCorrect; // is current instruction a branch instruction
//     logic branchOutcome;// 1 prediction correct 0 prediction incorrect
//     logic flag; // 1 taken branch 0 not taken branch
    
//     typedef enum logic [1:0]{
//         StronglyNotTaken = 2'b00,
//         WeaklyNotTaken = 2'b01,
//         WeaklyTaken = 2'b10,
//         StronglyTaken = 2'b11
//     } PredictionState;
    
//     PredictionState currentState;
        
//     //initial state
//     always_ff @(posedge rst) begin
//         if (rst) begin
//             currentState <= WeaklyNotTaken;
//             // flush <= 1'b0;
//         end
//     end 

    
//     always_comb begin
//         branchOutcome = ((pcSel == 2'b01 & branch & flag) || (pcSel == 2'b00 & branch & !flag) ) ? 1: 0;// 1 prediction correct 0 prediction incorrect
//         allCorrect = branchOutcome || !branch;
//         opcode = instruction[6:0];
//         imm = {instruction[31]? {20{1'b1}}:{20{1'b0}} , instruction[7], instruction[30:25],instruction[11:8],1'b0};// branch type immidiate
//         branchAdd = current_pc + imm;
        
//         //if the instruction is branch
//         currentBranch = (opcode == 7'b1100011)? 1: 0;

//         if (!allCorrect) begin // misprediction
//             flush = 1'b1;
//         end else begin
//             flush = flush_out_id;
//         end

//     //commented out for testing
//         // if (currentBranch)begin
//         //  //if a branch instruction
//         //         case(currentState) //branch 0 newpcsel = pcsel branch 1 
//         //             StronglyNotTaken,WeaklyNotTaken: // predict branch not taken
//         //                   begin 
//         //                     newPCSel = 2'b00; //should be pc sel pc+4 -00
//         //                     newAddress = current_pc4;
//         //                     altPC = branchAdd;// this should be ass
//         //                     // flag = 1'b0;
//         //                   end
//         //             WeaklyTaken,StronglyTaken: // predict branch taken
//         //                 begin 
//         //                     newPCSel = 2'b01;
//         //                     newAddress = branchAdd;
//         //                     altPC = current_pc4;
//         //                     // flag = 1'b1;
//         //                 end
//         //             default: newPCSel = 2'b00;
//         //           endcase      
//         // end else begin
//         //     newPCSel = pcSel;
//         //     newAddress = jumpAddress;
//         //     // flush = flush_out_id;
//         // end
//     end

//     always_ff @(negedge clk) begin
//         if (allCorrect) begin
//             if (currentBranch)begin
//             //if a branch instruction
//                     case(currentState) //branch 0 newpcsel = pcsel branch 1 
//                         StronglyNotTaken,WeaklyNotTaken: // predict branch not taken
//                             begin 
//                                 newPCSel <= 2'b00; //should be pc sel pc+4 -00
//                                 newAddress <= current_pc4;
//                                 altPC <= branchAdd;// this should be ass
//                                 flag <= 1'b0;
//                             end
//                         WeaklyTaken,StronglyTaken: // predict branch taken
//                             begin 
//                                 newPCSel <= 2'b01;
//                                 newAddress <= branchAdd;
//                                 altPC <= current_pc4;
//                                 flag <= 1'b1;
//                             end
//                         default: begin
//                             newPCSel <= 2'b00;
//                             flag <= 1'b0;
//                         end
//                     endcase      
//             end else begin
//                 newPCSel <= pcSel;
//                 newAddress <= jumpAddress;
//                 flag <= 1'b0;
//                 // flush = flush_out_id;
//             end
            
//         end else begin
//             newAddress <= altPC;
//             newPCSel <= 2'b01;
//         end

//         case (currentState)
//             StronglyNotTaken: currentState <= (branchOutcome) ? StronglyNotTaken: WeaklyTaken ; 
//             WeaklyNotTaken: currentState <= (branchOutcome) ? StronglyNotTaken : WeaklyTaken ;
//             WeaklyTaken: currentState <= (branchOutcome) ? StronglyTaken : WeaklyNotTaken;
//             StronglyTaken: currentState <= (branchOutcome) ? StronglyTaken : WeaklyTaken;
//             default:currentState <= WeaklyNotTaken; 
//         endcase

//     end

       
// //    always_comb begin //check the condition
// //             newAddress = altPC;
// //             newPCSel = 2'b00;
// //     end

// endmodule
