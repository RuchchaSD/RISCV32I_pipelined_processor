module EX_stage#( 
    parameter width = 32
)(  
    input logic [width - 1:0]   ID_EX_ReadData1,
    input logic [width - 1:0]   WB_Data,
    input logic [width - 1:0]   EX_MEM_Data,
    input logic [width - 1:0]   ID_EX_ReadData2,
    input logic [width - 1:0]   ID_EX_PC,
    input logic [width - 1:0]   ID_EX_Immediate,
//    input logic [1:0]           PCSrc,
    input logic [1:0]           ALUSrc1,
    input logic [1:0]           ALUSrc2,
    input logic [3:0]           ALUOp,
    input logic [6:0]           Func7,
    input logic [2:0]           Func3,
    input logic [4:0]           readReg1_out_id_ex,
    input logic [4:0]           readReg2_out_id_ex,
    input logic [4:0]           writeReg_out_ex_mem,
    input logic [4:0]           writeReg_out_mem_wb,
    output logic [width - 1:0]  Result , //aluOut_in_ex_mem in EXE-MEM latch,
    output logic [width - 1:0]  dataMWrite_in_ex_mem  
    );
    
    logic [1:0] ExMUX3_sel,ExMUX4_sel;
    logic [3:0] alu_cc;
    logic [width - 1:0]  TempALU_Opearand_1 ,TempALU_Opearand_2,ALU_Operand_1,ALU_Operand_2;


    assign dataMWrite_in_ex_mem = TempALU_Opearand_2;
    
   MUX31 ExMUX3 (
        .d0(ID_EX_ReadData1), //data from register rd1
        .d1(WB_Data), //output from wb
        .d2(EX_MEM_Data), //ALU result
        .s(ExMUX3_sel), //Forwarding unit control signal 1
        .y(TempALU_Opearand_1) // Output input 1 to ALUSrc1MUX
    ); 
    
   MUX31 ExMUX4 (
        .d0(ID_EX_ReadData2), //rd2
        .d1(WB_Data), //output from the wb
        .d2(EX_MEM_Data), //ALU result
        .s(ExMUX4_sel), //Forwarding unit control signal 2
        .y(TempALU_Opearand_2) // Output input  1 to ALUSrc2MUX
    );
    
   MUX31 ExMUX5 (
        .d0(TempALU_Opearand_1), //Output from Rdata1MUX
        .d1(ID_EX_PC), // PC
        .d2(0),  //zero
        .s(ALUSrc1), // ALUSrc1 control signal
        .y(ALU_Operand_1) //ALUSrcA
    );
    
   MUX31 ExMUX6 (
        .d0(TempALU_Opearand_2), //Output from Rdata2MUX
        .d1(ID_EX_Immediate), //Immediate output of immgen
        .d2(4), //four
        .s(ALUSrc2), // ALUSrc2
        .y(ALU_Operand_2) //ALUSrcB
    );
    
   ALU alu (
        .SrcA(ALU_Operand_1),  //ALUSrcA
        .SrcB(ALU_Operand_2),  //ALUSrcB
        .ALU_control(ALUOp), //AlU control signal from ALU CU
        .ALUResult(Result) // Connect ALUResult to ALU's output
    );
    
//   ALU_controller ac(
//        .ALUop(ALUOp), //ALU Op control signal
//        .Funct7(Func7), //Instruction [30,25,14-12,3] part that should be taken from the latch
//        .Funct3(Func3), //same as above?
//        .ALU_control(alu_cc) //ouput signal to alu
//   );
   
   ALU_data_forward(regWrite_out_ex_mem,regWrite_out_mem_wb,writeReg_out_ex_mem,writeReg_out_mem_wb,
                    readReg1_out_id_ex,readReg2_out_id_ex,
                    ExMUX3_sel,ExMUX4_sel);

endmodule

