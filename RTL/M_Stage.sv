`timescale 1ns/1ps
// The Data Unit is here!

//module DataMemory (
//    input [31:0]address, WriteDataM,
//    input [2:0]funct3M,
//    input CLK, WE, 
//    output reg [31:0]MemRead
//);

//reg [7:0] datamem [0:1023];

//always @(posedge CLK) begin
//    if (WE) begin
//        case (funct3M)
//            3'b000: //sb
//            begin
//                datamem[address] <= WriteDataM[7:0];
//            end 

//            3'b001: //sh
//            begin
//                datamem[address] <= WriteDataM[7:0];
//                datamem[address + 1] <= WriteDataM[15:8];
//            end

//            3'b010: //sw
//            begin
//                datamem[address] <= WriteDataM[7:0];
//                datamem[address + 1] <= WriteDataM[15:8];
//                datamem[address + 2] <= WriteDataM[23:16];
//                datamem[address + 3] <= WriteDataM[31:24];
//            end
//        endcase
//    end 

//    case (funct3M)
//        3'b000: //lb
//        begin
//            MemRead <= {{24{datamem[address][7]}}, datamem[address]};
//        end

//        3'b001: //lh
//        begin
//            MemRead <= {{16{datamem[address + 1][7]}}, datamem[address + 1], datamem[address]};
//        end
        
//        3'b010: //lw
//        begin
//            MemRead <= {datamem[address + 3], datamem[address + 2], datamem[address + 1], datamem[address]};
//        end

//        3'b100: //lbu
//        begin
//            MemRead <= {24'b0, datamem[address]};       
//        end

//        3'b101: //lhu
//        begin
//            MemRead <= {16'b0, datamem[address + 1], datamem[address]};
//        end

//        default:
//            MemRead <= 32'b0; 
//    endcase 
//end

//endmodule

module DataMemory (
    input CLK,
    input WE,
    input [31:0] address,
    input [31:0] WriteDataM,
    output [31:0] MemRead, 
    input [2:0] funct3M
);

blk_mem_gen_0 DMEM (
    .clka(CLK),
    .ena(1'b1),
    .wea(WE),
    .addra(address[11:2]),
    .dina(WriteDataM),
    .douta(MemRead)
);

endmodule

module M_W (
    input [31:0]PCPlus4M, ALU_ResultM, PCTargetM, ExtImmM, MemRead, 
    input [2:0]ResultSrcM, 
    input RegWM, MegaResetM_W, CLK, //BEWARE
    input [4:0]RDM,
    output [4:0]RDW,
    output RegWW,
    output [31:0]PCPlus4W, ALU_ResultW, PCTargetW, ExtImmW, MemReadW, 
    output [2:0]ResultSrcW 
);

Bit32PIPORegister M_W_PCPlus4(.write(PCPlus4M), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(PCPlus4W));
Bit32PIPORegister M_W_ALU_Result(.write(ALU_ResultM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ALU_ResultW));
Bit32PIPORegister M_W_PCTarget(.write(PCTargetM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(PCTargetW));
Bit32PIPORegister M_W_ImmExt(.write(ExtImmM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ExtImmW));
Bit32PIPORegister M_W_MemRead(.write(MemRead), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(MemReadW));

Bit5PIPORegister M_W_RD(.write(RDM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(RDW));

Bit3PIPORegister M_W_ResultSrc(.write(ResultSrcM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ResultSrcW));

PIPORegisterUnit M_W_RegW(.W(RegWM), .Ws(1'b1), .CLK(CLK), .Reset(MegaResetM_W), .R(RegWW));

endmodule