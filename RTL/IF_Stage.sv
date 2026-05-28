`timescale 1ns/1ps
//Will look at stall flush later on in life. 
module IF ( //StallF = 1 =>Stalled!
    input PCSrc, CLK, stallF, MegaResetIF, //BEWARE OF THE MEGA RESET!!
    input [31:0]PCTargetE,
    output [31:0]instruction, PCPlus4F, PCF 
);

wire [31:0]tPCPlus4, t0, tPCF, meminput;
assign t0 = PCSrc ? PCTargetE : tPCPlus4;
Bit32PIPORegister Reg_F(.write(t0), .Load_cmd(~stallF), .CLK(CLK), .Flush(MegaResetIF), .read(tPCF)); //was 1'b1

genvar i;
generate
    for (i = 0; i < 30 ; i = i + 1) begin
        assign meminput[i] = tPCF[i + 2];        
    end
    assign meminput[31] = 1'b0;
    assign meminput[30] = 1'b0;
endgenerate

// MEGA OPTIMIZATION BEGINS
assign tPCPlus4 = tPCF + 32'd4;
// FullAdder32Bits FA_IF_Stage (.Op1(tPCF), .Op2(32'd4), .Cin(1'b0), .R(tPCPlus4));

//MEGA OPTIMIZATION ENDS
assign PCPlus4F = tPCPlus4;
assign PCF = tPCF;

InstructionMemory IM_IF_Stage(.A(meminput), .instruction(instruction));

endmodule

module IF_D ( //StallD = 1 => Stalled!!
    input CLK, StallD, FlushD, MegaResetIF_D, //BEWARE!!
    input [31:0]IF_instruction, IF_PCF, IF_PCPlus4,
    output [31:0]D_instruction, D_PCD, D_PCPlus4D
);

//Again fo issue. Eating up 3ns.
Bit32PIPORegister IF_D_Instructions(.write(IF_instruction), .Load_cmd(~StallD), .Flush(MegaResetIF_D & FlushD), .read(D_instruction), .CLK(CLK));
Bit32PIPORegister IF_D_PCF(.write(IF_PCF), .Load_cmd(~StallD), .Flush(MegaResetIF_D), .read(D_PCD), .CLK(CLK));
Bit32PIPORegister IF_D_PCPlus4(.write(IF_PCPlus4), .Load_cmd(~StallD), .Flush(MegaResetIF_D), .read(D_PCPlus4D), .CLK(CLK));
    
endmodule