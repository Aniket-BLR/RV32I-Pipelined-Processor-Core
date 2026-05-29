`timescale 1ns/1ps
// Have created Control unit and ImmExt Unit here. 
//Hi!!

module Control_Unit (
    input [6:0]opcode, funct7,
    input [2:0]funct3,
    output RegW, MemW, Jump, Branch, ALUSrc, ALU_Sub_Ctrl, opcode_5C, opcode_3C, funct_7_5C,
    output [2:0]ResultSrc, ImmSrc, ALU_Control
);

assign ALU_Sub_Ctrl = 
    (opcode == 7'b0110011 && ((funct3 == 3'b000 && funct7 == 7'b0100000) || funct3 == 3'b010 || funct3 == 3'b011)) |
    (opcode == 7'b0010011 && (funct3 == 3'b010 || funct3 == 3'b011)) |
    (opcode == 7'b1100011); 

wire Decider;
assign Decider = 
    (opcode == 7'b0110111) |
    (opcode == 7'b0010111) |
    (opcode == 7'b0010011) |
    (opcode == 7'b0110011) |
    (opcode == 7'b0000011) |
    (opcode == 7'b0100011) |
    (opcode == 7'b1101111) |
    (opcode == 7'b1100111) |
    (opcode == 7'b1100011);

assign RegW = Decider ? (~opcode[5] | opcode[4] | opcode[3] | opcode[2]) : 1'b0;
assign MemW = Decider ? (~opcode[6] & opcode[5] & ~opcode[4] & ~opcode[3] & ~opcode[2]) : 1'b0;
assign Jump = Decider ? (opcode[6] & opcode[2]) : 1'b0;
assign Branch = Decider ? (opcode[6] & ~opcode[2]) : 1'b0;
assign ALUSrc = ~(opcode[6] ^ opcode[2]) & ~(opcode[5] & opcode[4]);

wire [2:0]w1, w2;
assign w1 = {opcode[5], opcode[4], opcode[2]};
assign w2 = {opcode[6], opcode[4], opcode[2]};

assign ResultSrc = (~opcode[6] & opcode[4] & opcode[2]) ? w1 : w2;
assign ImmSrc = Decider ? ({opcode[6], opcode[4], opcode[2]}) : 3'b111;

wire [2:0] tALU;
assign tALU = (~opcode[6] & ~opcode[4] & ~opcode[3] & ~opcode[2]) ? 3'b000 : funct3;
assign ALU_Control = Decider ? tALU : 3'b000;

assign funct_7_5C = funct7[5];
assign opcode_3C = opcode[3];
assign opcode_5C = opcode[5];

endmodule

module ExtendUnit (
    input [24:0]immediate,
    input [2:0]ImmControl,
    input op_5, op_3,
    output [31:0]final_immediate
);

wire [31:0]U, Ilbjalr, S, jal, B, t0, t1;
assign U = {immediate[24:5], 12'b0};
assign Ilbjalr = {{20{immediate[24]}}, immediate[24:13]};
assign S = {{20{immediate[24]}}, immediate[24:18], immediate[4:0]};
assign jal = {{11{immediate[24]}}, immediate[24], immediate[12:5], immediate[13], immediate[23:14], 1'b0};
assign B = {{19{immediate[24]}}, immediate[24], immediate[0], immediate[23:18], immediate[4:1], 1'b0};

assign t0 = op_5 ? S : Ilbjalr;
assign t1 = op_3 ? jal : Ilbjalr;

assign final_immediate = 
    (ImmControl == 3'b011) ? U :
    (ImmControl == 3'b010) ? Ilbjalr :
    (ImmControl == 3'b000) ? t0 :
    (ImmControl == 3'b101) ? t1 :
    (ImmControl == 3'b100) ? B :
    32'b0;

endmodule

module D (
    input [31:0]D_Instruction, D_PCD, D_PCPlus4D, ResultW, 
    input [4:0]RDW,
    input CLK, RegWW,
    output [31:0]PCD, RD1, RD2, ExtImmD, PCPlus4D,
    output RegWD, MemWD, JumpD, BranchD, ALUSrcD, ALU_Sub_CtrlD, funct_7_5CD,  
    output [2:0]ResultSrcD, ALU_ControlD, funct3D, 
    output [4:0]RS1D, RS2D, RDD
);

wire opcode_5CD, opcode_3CD;
wire [2:0]ImmSrcD;

RegisterFile RF_D(
    .A1(D_Instruction[19:15]), 
    .A2(D_Instruction[24:20]), 
    .A3(RDW), 
    .WD(ResultW), 
    .CLK(~CLK), //I need this to write on negative edge of clock cycle.  
    .Reg_W(RegWW), 
    .Reset_Reg_File(1'b1), 
    .RS1(RD1),
    .RS2(RD2)
    );

Control_Unit CU(
    .opcode(D_Instruction[6:0]), 
    .funct7(D_Instruction[31:25]), 
    .funct3(D_Instruction[14:12]),
    .RegW(RegWD),
    .MemW(MemWD),
    .Jump(JumpD),
    .Branch(BranchD),
    .ALUSrc(ALUSrcD),
    .ALU_Sub_Ctrl(ALU_Sub_CtrlD),
    .funct_7_5C(funct_7_5CD),
    .opcode_3C(opcode_3CD),
    .opcode_5C(opcode_5CD),
    .ResultSrc(ResultSrcD),
    .ALU_Control(ALU_ControlD),
    .ImmSrc(ImmSrcD)
    );

ExtendUnit E0_D(
    .immediate(D_Instruction[31:7]), 
    .ImmControl(ImmSrcD), 
    .op_5(opcode_5CD), 
    .op_3(opcode_3CD), 
    .final_immediate(ExtImmD));

assign PCD = D_PCD;
assign PCPlus4D = D_PCPlus4D;
assign RS1D = D_Instruction[19:15];
assign RS2D = D_Instruction[24:20];
assign RDD = D_Instruction[11:7];
assign funct3D = D_Instruction[14:12];

endmodule

module D_EX ( //FlushE displaying fo = 191. Eating 4ns. To generate a nop, we effectively need to make MemW and RegW = 0 and Branch/Jump = 0; 
    input CLK, FlushE, MegaResetD_EX, StallE, //Active Low Flushing BEWARE!!
    //Control Signals HERE
    input RegWD, BranchD, JumpD, MemWD, ALUSrcD, ALU_Sub_CtrlD, funct_7_5CD,
    input [2:0]ResultSrcD, ALU_ControlD, funct3D, 
    input [4:0]RS1D, RS2D, RDD, 
    input [31:0]PCD, RD1, RD2, ExtImmD, PCPlus4D,
    //input ends. Output begins.
    output RegWE, BranchE, JumpE, MemWE, ALUSrcE, ALU_Sub_CtrlE, funct_7_5CE, 
    output [2:0]ResultSrcE, ALU_ControlE, funct3E,
    output [4:0]RS1E, RS2E, RDE,
    output [31:0]PCE, RD1E, RD2E, ExtImmE, PCPlus4E
);
    
    Bit32PIPORegister D_EX_PCD(.write(PCD), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(PCE));
    Bit32PIPORegister D_EX_RD1(.write(RD1), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(RD1E));
    Bit32PIPORegister D_EX_RD2(.write(RD2), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(RD2E));
    Bit32PIPORegister D_EX_ExtImm(.write(ExtImmD), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(ExtImmE));
    Bit32PIPORegister D_EX_PCPlus4(.write(PCPlus4D), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(PCPlus4E));

    Bit5PIPORegister D_EX_RS1(.write(RS1D), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(RS1E));
    Bit5PIPORegister D_EX_RS2(.write(RS2D), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(RS2E));
    Bit5PIPORegister D_EX_RD(.write(RDD), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(RDE));

    Bit3PIPORegister D_EX_ResultSrc(.write(ResultSrcD), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(ResultSrcE));
    Bit3PIPORegister D_EX_ALUControl(.write(ALU_ControlD), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(ALU_ControlE));
    Bit3PIPORegister D_EX_funct3(.write(funct3D), .Load_cmd(~StallE), .CLK(CLK), .Flush(1'b1 & MegaResetD_EX), .read(funct3E));

    PIPORegisterUnit D_EX_RegW(.W(RegWD), .Ws(~StallE), .CLK(CLK), .Reset(FlushE & MegaResetD_EX), .R(RegWE)); //1  MAINTAIN FLUSHE HERE!!
    PIPORegisterUnit D_EX_Branch(.W(BranchD), .Ws(~StallE), .CLK(CLK), .Reset(FlushE & MegaResetD_EX), .R(BranchE)); //2
    PIPORegisterUnit D_EX_Jump(.W(JumpD), .Ws(~StallE), .CLK(CLK), .Reset(FlushE & MegaResetD_EX), .R(JumpE)); //3
    PIPORegisterUnit D_EX_Mem(.W(MemWD), .Ws(~StallE), .CLK(CLK), .Reset(FlushE & MegaResetD_EX), .R(MemWE));//4
    PIPORegisterUnit D_EX_ALUSrc(.W(ALUSrcD), .Ws(~StallE), .CLK(CLK), .Reset(1'b1 & MegaResetD_EX), .R(ALUSrcE)); //5
    PIPORegisterUnit D_EX_ALU_Sub_Ctrl(.W(ALU_Sub_CtrlD), .Ws(~StallE), .CLK(CLK), .Reset(1'b1 & MegaResetD_EX), .R(ALU_Sub_CtrlE)); //6
    PIPORegisterUnit D_EX_funct_7_5C(.W(funct_7_5CD), .Ws(~StallE), .CLK(CLK), .Reset(1'b1 & MegaResetD_EX), .R(funct_7_5CE));
endmodule