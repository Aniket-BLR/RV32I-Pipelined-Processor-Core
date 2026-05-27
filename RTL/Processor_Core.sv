`timescale 1ns/1ps
//Wirename = Signal_driver_receiver
module RV32I_Processor_Core (
    input CLK, ProcessorReset, //Active Low
    output [31:0]PC_OUT,
    output [31:0]ALU_OUT,
    output [31:0]INSTR_OUT
    //Added these 3 outputs to run implementation
);

wire tPCSrc, tStallF, tStallD, tFlushF, tFlushD, tFlushE;
wire [31:0]tPCTarget_E_F,tinstruction_F_IFB, tPCPlus4_F_IFB, tPCF_F_IFB;
wire [31:0]tinstruction_IFB_D, tPC_IFB_D, tPCPlus4_IFB_D;

wire [31:0]tPC_D_DB, tRD1_D_DB, tRD2_D_DB, tExtImm_D_DB, tPCPlus4_D_DB; 
wire tRegW_D_DB, tMemW_D_DB, tJump_D_DB, tBranch_D_DB, tALUSrc_D_DB, tALUSubCtrl_D_DB, tfunct75_D_DB;
wire [2:0]tResultSrc_D_DB, tALUCtrl_D_DB, tfunct3_D_DB;
wire[4:0]tRS1_D_DBH, tRS2_D_DBH, tRD_D_DB;

wire tRegW_DB_EBH, tMemW_DB_EB, tBranch_DB_H, tJump_DB_H, tALUSrc_DB_E, tALUSubCtrl_DB_E, tfunct75_DB_E;
wire [2:0]tResultSrc_DB_EBH, tALUCtrl_DB_E, tfunct3_DB_EB;
wire [4:0]tRS1_DB_H, tRS2_DB_H, tRD_DB_EBH; 
wire [31:0]tPC_DB_E, tRD1_DB_E, tRD2_DB_E, tPCPlus4_DB_EB, tImmExt_DB_EBE;

wire [1:0]tForwardAE_H_E, tForwardBE_H_E;
wire [31:0]tALUResult_M_E, tWriteData_E_EB, tALUResult_E_EB;
wire tBFlag_E_H;

wire tRegW_EB_MBH, tMemW_EB_M;
wire [2:0]tResultSrc_EB_MB, tfunct3_EB_M;
wire [4:0]tRD_EB_MBH;
wire [31:0]tPCPlus4_EB_MB, tWriteData_EB_M, tPCTarget_EB_MB, tExtImm_EB_MB;

wire [31:0]tMemRead_M_MB;

wire [31:0]tResult_W_D, tMemRead_W, tPCPlus4_W, tALUResult_W, tPCTarget_W, tExtImm_W; //REMEMBER! 
wire [2:0]tResultSrc_W;
wire [4:0]tRD_W_DH; 
wire tRegW_W_DH; 

IF FetchStage(
    .MegaResetIF(ProcessorReset), //1bit
    .PCSrc(tPCSrc), //1bit 
    .CLK(CLK), //1bit
    .stallF(tStallF), //1bit
    .PCTargetE(tPCTarget_E_F), //32bit
    //Outputs
    .instruction(tinstruction_F_IFB), //32bits
    .PCPlus4F(tPCPlus4_F_IFB), //32bit
    .PCF(tPCF_F_IFB) //32bit
    );

IF_D IF_DBuffer(
    .MegaResetIF_D(ProcessorReset), //1bit
    .CLK(CLK), //1bit
    .StallD(tStallD), //1bit
    .FlushD(tFlushD), //1bit
    .IF_instruction(tinstruction_F_IFB), //32bit
    .IF_PCF(tPCF_F_IFB), //32bit
    .IF_PCPlus4(tPCPlus4_F_IFB), //32bit
    //Outputs
    .D_instruction(tinstruction_IFB_D), //32bit
    .D_PCD(tPC_IFB_D), //32bit
    .D_PCPlus4D(tPCPlus4_IFB_D) //32bit
);

D DecodeStage(
    .D_Instruction(tinstruction_IFB_D), //32bit
    .D_PCD(tPC_IFB_D), //32bit
    .D_PCPlus4D(tPCPlus4_IFB_D), //32bit
    .ResultW(tResult_W_D), //32bit
    .RDW(tRD_W_DH), //5bit
    .CLK(CLK), //1bit
    .RegWW(tRegW_W_DH), //1bit
    //Outputs
    .PCD(tPC_D_DB), //32bit
    .RD1(tRD1_D_DB), //32bits
    .RD2(tRD2_D_DB), //32bits
    .ExtImmD(tExtImm_D_DB), //32bits
    .PCPlus4D(tPCPlus4_D_DB), //32bits
    .RegWD(tRegW_D_DB), //1bit
    .MemWD(tMemW_D_DB), //1bit
    .JumpD(tJump_D_DB), //1bit
    .BranchD(tBranch_D_DB), //1bit
    .ALUSrcD(tALUSrc_D_DB), //1bit
    .ALU_Sub_CtrlD(tALUSubCtrl_D_DB), //1bit
    .funct_7_5CD(tfunct75_D_DB), //1bit
    .ResultSrcD(tResultSrc_D_DB), //3bit
    .ALU_ControlD(tALUCtrl_D_DB), //3bit
    .funct3D(tfunct3_D_DB), //3bit
    .RS1D(tRS1_D_DBH), //5bit
    .RS2D(tRS2_D_DBH), //5bit
    .RDD(tRD_D_DB) //5bit
);

D_EX D_EXBuffer(
    .MegaResetD_EX(ProcessorReset), //1bit
    .CLK(CLK), //1bit
    .FlushE(tFlushE), //1bit
    .RegWD(tRegW_D_DB), //1bit
    .BranchD(tBranch_D_DB), //1bit
    .JumpD(tJump_D_DB), //1bit
    .MemWD(tMemW_D_DB), //1bit
    .ALUSrcD(tALUSrc_D_DB), //1bit
    .ALU_Sub_CtrlD(tALUSubCtrl_D_DB), //1bit
    .funct_7_5CD(tfunct75_D_DB), //1bit
    .ResultSrcD(tResultSrc_D_DB), //3bit
    .ALU_ControlD(tALUCtrl_D_DB), //3bit
    .funct3D(tfunct3_D_DB), //3bit
    .RS1D(tRS1_D_DBH), //5bit
    .RS2D(tRS2_D_DBH), //5bit
    .RDD(tRD_D_DB), //5bit
    .PCD(tPC_D_DB), //32bit
    .RD1(tRD1_D_DB), //32bit
    .RD2(tRD2_D_DB), //32bit
    .ExtImmD(tExtImm_D_DB), //32bit
    .PCPlus4D(tPCPlus4_D_DB), //32bit
    //Outputs
    .RegWE(tRegW_DB_EBH), //1bit
    .BranchE(tBranch_DB_H), //1bit
    .JumpE(tJump_DB_H), //1bit
    .MemWE(tMemW_DB_EB), //1bit
    .ALUSrcE(tALUSrc_DB_E), //1bit
    .ALU_Sub_CtrlE(tALUSubCtrl_DB_E), //1bit
    .funct_7_5CE(tfunct75_DB_E), //1bit
    .ResultSrcE(tResultSrc_DB_EBH), //3bit
    .ALU_ControlE(tALUCtrl_DB_E), //3bit
    .funct3E(tfunct3_DB_EB), //3bit
    .RS1E(tRS1_DB_H), //5bit
    .RS2E(tRS2_DB_H), //5bit
    .RDE(tRD_DB_EBH), //5bit
    .PCE(tPC_DB_E), //32bit
    .RD1E(tRD1_DB_E), //32bit
    .RD2E(tRD2_DB_E), //32bit
    .ExtImmE(tImmExt_DB_EBE), //32bit
    .PCPlus4E(tPCPlus4_DB_EB) //32bit
);

EX ExecuteStage(
    .ALU_ResultM(tALUResult_M_E), //32bit
    .ResultW(tResult_W_D), //32bit
    .RD1E(tRD1_DB_E), //32bit
    .RD2E(tRD2_DB_E), //32bit
    .PCE(tPC_DB_E), //32bit
    .ExtImmE(tImmExt_DB_EBE), //32bit
    .ForwardAE(tForwardAE_H_E), //2bit
    .ForwardBE(tForwardBE_H_E), //2bit
    .ALUSrcE(tALUSrc_DB_E), //1bit
    .ALU_Sub_CtrlE(tALUSubCtrl_DB_E), //1bit
    .funct_7_5CE(tfunct75_DB_E), //1bit
    .ALU_ControlE(tALUCtrl_DB_E), //3bit
    //Outputs
    .PCTargetE(tPCTarget_E_F), //32bit
    .WriteDataE(tWriteData_E_EB), //32bit
    .ALU_ResultE(tALUResult_E_EB), //32bit
    .BFlag(tBFlag_E_H) //1bit
);

EX_M EX_MBuffer(
    .MegaResetEX_M(ProcessorReset), //1bit
    .RegWE(tRegW_DB_EBH), //1bit
    .CLK(CLK), //1bit
    .MemWE(tMemW_DB_EB), //1bit
    .ResultSrcE(tResultSrc_DB_EBH), //3bit
    .funct3E(tfunct3_DB_EB), //3bit
    .PCPlus4E(tPCPlus4_DB_EB), //32bit
    .WriteDataE(tWriteData_E_EB), //32bit
    .ALU_ResultE(tALUResult_E_EB), //32bit
    .PCTargetE(tPCTarget_E_F), //32bit
    .ExtImmE(tImmExt_DB_EBE), //32bit
    .RDE(tRD_DB_EBH), //5bit
    //Outputs
    .RegWM(tRegW_EB_MBH), //1bit
    .MemWM(tMemW_EB_M), //1bit
    .ResultSrcM(tResultSrc_EB_MB), //3bit
    .funct3M(tfunct3_EB_M), //3bit
    .RDM(tRD_EB_MBH), //5bit
    .PCPlus4M(tPCPlus4_EB_MB), //32bit
    .WriteDataM(tWriteData_EB_M), //32bit
    .ALU_ResultM(tALUResult_M_E), //32bit
    .PCTargetM(tPCTarget_EB_MB), //32bit
    .ExtImmM(tExtImm_EB_MB) //32bit
);

DataMemory MemoryStage(
    .address(tALUResult_M_E), //32bit
    .WriteDataM(tWriteData_EB_M), //32bit
    .funct3M(tfunct3_EB_M), //3bit
    .CLK(CLK),
    .WE(tMemW_EB_M),
    //Output
    .MemRead(tMemRead_M_MB) //32bit reg or something.
);

M_W M_WBuffer(
    .CLK(CLK), //1bit
    .MegaResetM_W(ProcessorReset), //1bit
    .MemRead(tMemRead_M_MB), //32bit
    .PCPlus4M(tPCPlus4_EB_MB), //32bit
    .ALU_ResultM(tALUResult_M_E), //32bit
    .PCTargetM(tPCTarget_EB_MB), //32bit
    .ExtImmM(tExtImm_EB_MB), //32bit
    .RDM(tRD_EB_MBH), //5bit
    .ResultSrcM(tResultSrc_EB_MB), //3bit
    .RegWM(tRegW_EB_MBH), //1bit
    //Outputs
    .MemReadW(tMemRead_W), //32bit
    .PCPlus4W(tPCPlus4_W), //32bit
    .ALU_ResultW(tALUResult_W), //32bit
    .PCTargetW(tPCTarget_W), //32bit
    .ExtImmW(tExtImm_W), //32bit
    .RDW(tRD_W_DH), //5bit
    .ResultSrcW(tResultSrc_W), //3bit
    .RegWW(tRegW_W_DH) //1bit
);

HazardUnit HU(
    .PCSrcReset(ProcessorReset), //1bit
    .RDE(tRD_DB_EBH), //5bit
    .RS1E(tRS1_DB_H), //5bit
    .RS2E(tRS2_DB_H), //5bit
    .RS1D(tRS1_D_DBH), //5bit
    .RS2D(tRS2_D_DBH), //5bit
    .RDM(tRD_EB_MBH), //5bit
    .RDW(tRD_W_DH), //5bit
    .ResultSrcE(tResultSrc_DB_EBH), //3bit
    .RegWW(tRegW_W_DH), //1bit
    .RegWM(tRegW_EB_MBH), //1bit
    .JumpE(tJump_DB_H), //1bit
    .BranchE(tBranch_DB_H), //1bit
    .BFlag(tBFlag_E_H), //1bit
    .CLK(CLK), //1bit
    .RegWE(tRegW_DB_EBH), //1bit
    //Outputs
    .StallF(tStallF), //1bit reg 
    .StallD(tStallD), //1bit reg
    .FlushD(tFlushD), //1bit reg
    .FlushE(tFlushE), //1bit reg
    .ForwardAE(tForwardAE_H_E), //2bit reg
    .ForwardBE(tForwardBE_H_E), //2bit reg
    .PCSrcE(tPCSrc) //1bit
);

assign tResult_W_D = 
    (tResultSrc_W == 3'b111) ? tExtImm_W :
    (tResultSrc_W == 3'b011) ? tPCTarget_W :
    (tResultSrc_W == 3'b000) ? tMemRead_W :
    (tResultSrc_W == 3'b010) ? tALUResult_W :
    (tResultSrc_W == 3'b101) ? tPCPlus4_W :
    32'b0;
    
 assign PC_OUT = tPCF_F_IFB;
 assign ALU_OUT = tALUResult_W;
 assign INSTR_OUT = tinstruction_F_IFB;
    
endmodule