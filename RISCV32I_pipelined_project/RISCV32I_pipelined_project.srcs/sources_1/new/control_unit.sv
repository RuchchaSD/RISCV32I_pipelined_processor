`timescale 1ns / 1ps

module control_unit(
//inputs
    input logic clk,
    input logic rst,
    input logic [31:0] instruction,
    // input logic beq,
    // input logic blt,
    // input logic [1:0] diff, //0:rs1, 1:pc
    // input logic [1:0] ilt,
//outputs
    // output logic [3:0] immSel,// not needed
    output logic [3:0] aluControl,
    output logic [1:0] ALUSrc1,
    output logic [1:0] ALUSrc2,
    output logic [2:0] memRead,
    output logic regWrite, 
    output logic [2:0] memWrite,
    output logic wbMuxsel,
    output logic branch, 
    output logic isJalr,
    output logic EX_Flush,
    output logic Id_Flush,
    output logic If_Flush,
    output logic Jump,
    logic [2:0] funct3
    );
    
    logic [6:0] opcode;
    logic [1:0] pccon;
    logic [2:0] extOp;
    logic [6:0] funct7;
    logic [2:0] memWriteCon;
    // logic [3:0] aluOp;
    logic jump;
    logic [31:0] microIns;
    logic [7:0] microOp,insmicroOp;
    logic [7:0] nextOp,tempOp;
    
    
    
    logic  [31 :0] Control[ 255:0];
//micro instructions
    initial begin
        for (int i=0; i < 256; ++i) begin
            Control[i] = 32'b00000000000000000000000001110000;
        end
        Control[1] = 32'b00000000010000000000000100000000; //ADD
        Control[2] = 32'b00000000010000000000001000000000; //SUB
        Control[3] = 32'b00000000010000000000001100000000; //SLL
        Control[5] = 32'b00000000010000000000010000000000; //SLT
        Control[7] = 32'b00000000010000000000010100000000; //SLTU
        Control[9] = 32'b00000000010000000000011000000000; //XOR
        Control[11] = 32'b00000000010000000000100000000000; //SRL
        Control[12] = 32'b00000000010000000000011100000000; //SRA
        Control[13] = 32'b00000000010000000000100100000000; //OR
        Control[15] = 32'b00000000010000000000101000000000; //AND
        Control[10] = 32'b00111100000000; //MUL

        //LUI
        Control[17] = 32'b00000000010000000110000100000000; //LUI
        //AUIPC
        Control[129] = 32'b00000000010000000101000100000000; //AUIPC

        //JALR
        Control[33] = 32'b01110010010000001001000100000000; //JALR
        //Itype Arith
        Control[49] = 32'b00000000010000000100000100000000; //ADDI
        Control[53] = 32'b00000000010000000100010000000000; //SLTI
        Control[55] = 32'b00000000010000000100010100000000; //SLTIU
        Control[57] = 32'b00000000010000000100011000000000; //XORI
        Control[61] = 32'b00000000010000000100100100000000; //ORI
        Control[63] = 32'b00000000010000000100101000000000; //ANDI
        Control[51] = 32'b00000000010000000100001100000000; //SLLI
        Control[59] = 32'b00000000010000000100100000000000; //SRLI
        Control[60] = 32'b00000000010000000100011100000000; //SRAI

        //I type load
        Control[65] = 32'b00000000110000000100000100000000; //LB
        Control[67] = 32'b00000000110000010100000100000000; //LH
        Control[69] = 32'b00000000110000100100000100000000; //LW
        Control[73] = 32'b00000000110001000100000100000000; //LBU
        Control[75] = 32'b00000000110001010100000100000000; //LHU

        //Stype
        Control[81] = 32'b00000000000110000100000100000000; //SB
        Control[83] = 32'b00000000000100000100000100000000; //SH
        Control[85] = 32'b00000000000010000100000100000000; //SW

        //sb type
        Control[97] = 32'b01000101000000000000000100000000; //BEQ
        Control[99] = 32'b01000101000000000000000100000000; //BNE
        Control[105] = 32'b01000101000000000000000100000000; //BLT
        Control[107] = 32'b01000101000000000000000100000000; //BGE
        Control[109] = 32'b01000101000000000000000100000000; //BLTU
        Control[111] = 32'b01000101000000000000000100000000; //BGEU

        //Jtype
        Control[113] = 32'b10110000010000001001000100000000; //JAL

        //MEMCOPY 
        Control[145] = 32'b11000110010010; //MEMCOPY
        Control[147] = 32'b11000110010100;
        Control[149] = 32'b11000110010010;
        Control[150] = 32'b00000000000000;


    end


    
    
//decode
    always_comb 
    begin
        opcode = instruction[6:0];
        funct3 = instruction[14:12];
        funct7 = instruction[31:25];
        
        tempOp = microIns[7:0];
        aluControl = microIns[11:8];
        ALUSrc1 = microIns[13:12];
        ALUSrc2 = microIns[15:14];
        memRead = microIns[18 : 16];
        memWrite = microIns[21 : 19];
        regWrite = microIns[22];
        wbMuxsel = microIns[23];
        branch = microIns[24];
        isJalr = microIns[25];
        EX_Flush = microIns[26];
        Id_Flush = microIns[27];
        If_Flush = microIns[28];
        Jump = microIns[29];
        pccon = microIns[31:30];



        // pccon = microIns[19:18];
        // regWrite = microIns[17];
        // memWriteCon = microIns[16:14];
        // branch = microIns[13];
        // aSel = microIns[12:11];
        // bSel = microIns[10:9];
        // wSel = microIns[8:7];
        // extSel = microIns[6:4];
        // // memWsel = microIns[4];
        // increment = microIns[3];
        // counterEn = microIns[2];
        // memWsel = microIns[1];
        // dataregWrite = microIns[0];
    end
    
   
//prepare microinstruction and get microinstruction from control memory  
    logic [6:0] R_TYPE, LW, SW, ITYPE_ADD, BR, JALR, JAL,AUIPC,LUI,MEMCOPY;
    assign  BR     = 7'b1100011;
    assign  R_TYPE = 7'b0110011;
    assign  LW     = 7'b0000011;
    assign  SW     = 7'b0100011;
    assign  ITYPE_ADD = 7'b0010011; //addi,ori,andi
    assign  JAL = 7'b1101111;
    assign  JALR = 7'b1100111;
    assign  AUIPC = 7'b0010111;
    assign  LUI = 7'b0110111;
    assign MEMCOPY = 7'b1101011;
    
    always_comb
        case(opcode)
            R_TYPE : begin
                // _[7:4] = 4'b0000;
                // _[3:1] = funct3;
                // _[0] = funct7[5];
                insmicroOp ={4'b0000, funct3, funct7[5]};
                // insmicroOp = _ +1;
            end
            LUI : begin 
                insmicroOp = 16; 
                // insmicroOp = _ +1;
    
            end
            JALR : begin
                insmicroOp = 32;
                // insmicroOp = _ +1;
            end
            ITYPE_ADD : begin
                insmicroOp[7:4] = 4'b0011;
                insmicroOp[3:1] = funct3;
                if(funct3 == 3'b101)
                    insmicroOp[0] = funct7[5];
                else
                    insmicroOp[0] = 0;
                
                insmicroOp = {4'b0011, funct3, funct3 == 3'b101 ? funct7[5] : 1'b0};
                // insmicroOp = _ +1;
                    
            end
            LW : begin 
                // _ = 4'b0100;
                // _[3:1] = funct3;
                // _[0] = 0;
                insmicroOp = {4'b0100, funct3, 1'b0};
                // insmicroOp = _ +1;
            end
            SW : begin
                // _ = 4'b0101;
                // _[3:1] = funct3;
                // _[0] = 0;
                insmicroOp = {4'b0101, funct3, 1'b0};
                // insmicroOp = _ +1;
            end
            BR : begin
                // _ = 4'b0110;
                // _[3:1] = funct3;
                // _[0] = 0;
                insmicroOp = {4'b0110, funct3, 1'b0}; 
                // insmicroOp = _ +1;
            end
            JAL : begin
                insmicroOp = 112;
                // insmicroOp = _ +1;
            end
            AUIPC : begin
                insmicroOp = 128;
                // insmicroOp = _ +1;
            end
            MEMCOPY : begin
                insmicroOp = 144;

                // insmicroOp = _ +1;
            end
            default:
                insmicroOp = -1;
        endcase
    
// //get microinstruction from control memory
    //     // if(pccon == 2'b11)
            
    //     //     microOp = nextOp;
    //     // else
    //     //     microOp = insmicroOp + 1 ;

    //     // if(rst)
    //     //     microOp = 0;
//change this for multi cycle instructios
    // always_ff @(negedge clk) begin
    //     if(rst) begin
    //         microOp = 0;
    //     end
    //     else begin
    //         if(pccon == 2'b11)
            
    //             microOp <= nextOp +1;
    //         else
    //             microOp <= insmicroOp + 1 ;
    //     end
    // end

//combinational microOp assignment
    assign microOp = pccon == 2'b11 ? nextOp +1 : insmicroOp + 1;

    always_comb begin
        if(rst)begin
            microIns = Control[0];
        end
        else begin
            microIns = Control[microOp];
        end
    end

//change nextOp
always_comb
    if(tempOp == 8'b10010100)//memcopy
        nextOp = {tempOp[7:1],jump};
    else
        nextOp = tempOp;


//pcSel //beq,blt
    // always_comb begin
    //     if(pccon == 1)
    //         case(funct3)
    //             3'b000://BEQ
    //                 if(beq)
    //                     pcSel = 1; 
    //                 else 
    //                     pcSel = 0;  
    //             3'b001://BNE
    //                 if(!beq)
    //                     pcSel = 1;
    //                 else 
    //                     pcSel = 0;
    //             3'b100://BLT
    //                 if(blt)
    //                     pcSel = 1;
    //                 else 
    //                     pcSel = 0;
    //             3'b101://BGE
    //                 if(!blt)
    //                     pcSel = 1;
    //                 else 
    //                     pcSel = 0;
    //             3'b110://BLTU
    //                 if(blt)
    //                     pcSel = 1;
    //                 else 
    //                     pcSel = 0;
    //             3'b111://BGEU
    //                 if(!blt)
    //                     pcSel = 1;
    //                 else 
    //                     pcSel = 0;
    //             default:
    //                  pcSel = 0;
    //         endcase
    //     else if(pccon == 2)
    //         pcSel = 1;
    //     else if(pccon == 3)
    //         pcSel = 2;
    //     else
    //         pcSel = 0;
    //     end
    
    
//determine jump and extSel
    // always_comb begin
    //     if(tempOp == 8'b10010100 && ( ilt[1] == 1'b1 || ilt[0] == 1'b1 ) ) // imm == cnt
    //         jump = 1;
    //     else
    //         jump = 0;

    //     if(tempOp == 8'h94 && ilt[0] == 1'b1)  //$unsigned(imm) < $unsigned(cntPlus4)                                   
    //         case(diff)
    //             2'b00: memWrite = 3'b000;
    //             2'b01: memWrite = 3'b100;
    //             2'b10: memWrite = 3'b101;
    //             2'b11: memWrite = 3'b110;
    //             default: memWrite = 3'b000;
    //         endcase
    //     else
    //         memWrite = memWriteCon;
    //         // memWrite = 3;

    // end




endmodule
