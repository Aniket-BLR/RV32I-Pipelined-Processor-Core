`timescale 1ns/1ps

module EX (
    input [31:0]ALU_ResultM, ResultW, RD1E, RD2E, PCE, ExtImmE, 
    input [1:0] ForwardAE, ForwardBE, 
    input ALUSrcE, ALU_Sub_CtrlE, funct_7_5CE, 
    input [2:0]ALU_ControlE,
    output [31:0]PCTargetE, WriteDataE, ALU_ResultE, 
    output BFlag 
);

wire [31:0]SrcAE, SrcBE, SrcBEi;
assign SrcAE = 
    (ForwardAE == 2'b00) ? RD1E : 
    (ForwardAE == 2'b01) ? ResultW :
    (ForwardAE == 2'b10) ? ALU_ResultM :
    32'b0;

assign SrcBEi = 
    (ForwardBE == 2'b00) ? RD2E :
    (ForwardBE == 2'b01) ? ResultW :
    (ForwardBE == 2'b10) ? ALU_ResultM :
    32'b0;

assign WriteDataE = SrcBEi;
assign SrcBE = ALUSrcE ? ExtImmE : SrcBEi; //This finally goes into ALU.

ALU EX_A(.funct_7_5(funct_7_5CE), .ALU_Sub_Ctrl(ALU_Sub_CtrlE), .A(SrcAE), .B(SrcBE), .ALU_Control(ALU_ControlE), .ALU_Result(ALU_ResultE), .ALU_Flag(BFlag));
FullAdder32Bits FA_EX(.Op1(PCE), .Op2(ExtImmE), .Cin(1'b0), .R(PCTargetE));
    
endmodule

module EX_M (
    input RegWE, MemWE, CLK, MegaResetEX_M, //BEWARE
    input [2:0]ResultSrcE, funct3E,
    input [31:0]PCPlus4E, WriteDataE, ALU_ResultE, PCTargetE, ExtImmE,
    input [4:0]RDE,
    output [4:0]RDM,
    output RegWM, MemWM, 
    output [2:0]ResultSrcM, funct3M,
    output[31:0]PCPlus4M, WriteDataM, ALU_ResultM, PCTargetM, ExtImmM
);

PIPORegisterUnit EX_M_RegW(.W(RegWE), .Ws(1'b1), .CLK(CLK), .Reset(MegaResetEX_M), .R(RegWM));
PIPORegisterUnit EX_M_MemW(.W(MemWE), .Ws(1'b1), .CLK(CLK), .Reset(MegaResetEX_M), .R(MemWM));

Bit3PIPORegister EX_M_ResultSrc(.write(ResultSrcE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(ResultSrcM));
Bit3PIPORegister EX_M_funct3(.write(funct3E), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(funct3M));

Bit5PIPORegister EX_M_RD(.write(RDE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(RDM));

Bit32PIPORegister EX_M_PCPlus4(.write(PCPlus4E), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(PCPlus4M));
Bit32PIPORegister EX_M_WriteData(.write(WriteDataE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(WriteDataM));
Bit32PIPORegister EX_M_ALU_Result(.write(ALU_ResultE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(ALU_ResultM));
Bit32PIPORegister EX_M_PCTarget(.write(PCTargetE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(PCTargetM));
Bit32PIPORegister EX_M_ImmExt(.write(ExtImmE), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetEX_M), .read(ExtImmM));
    
endmodule