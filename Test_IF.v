`timescale 1ns/1ps
module testbench;
    reg PCSrc, CLK, stallF, StallD, FlushD;
    reg [31:0]PCTargetE;
    wire [31:0]instruction, PCPlus4F, PCF, D_instruction, D_PCD, D_PCPlus4D;
    IF DUT(.PCSrc(PCSrc), .CLK(CLK), .PCTargetE(PCTargetE), .stallF(stallF), .instruction(instruction), .PCPlus4F(PCPlus4F), .PCF(PCF));
    IF_D DUT2(.CLK(CLK), .StallD(StallD), .FlushD(FlushD), .IF_instruction(instruction), .IF_PCF(PCF), .IF_PCPlus4(PCPlus4F), .D_instruction(D_instruction), .D_PCD(D_PCD), .D_PCPlus4D(D_PCPlus4D));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        //$monitor($time, " CLK = %b, PCSrc = %b, Target = %b, curr_PC = %b, MemFetched = %b, PC+4 = %b, stallF = %b", CLK, PCSrc, PCTargetE, PCF, instruction, PCPlus4F, stallF);
        $monitor($time, "CLK: %b, PCSrc: %b, Instruction Fetched: %b, curr_PC = %b, stallD = %b, FlushD = %b", CLK, PCSrc, D_instruction, D_PCD, StallD, FlushD);
    end

    initial CLK = 0;
    always #(1) CLK = ~CLK;

    initial begin
        PCSrc = 1;
        stallF = 0;
        StallD = 0;
        PCTargetE = 32'd4;
        FlushD = 0;
    end

    initial begin
        #2; //Lemme see the original state.
        #0.5 PCSrc = 0;
        #4 PCSrc = 1;
        #16 $finish;
    end
endmodule