`timescale 1ns/1ps

module HazardUnit ( //Flushing is ACTIVE LOW.
    input [4:0]RDE, RS1E, RS2E, RS1D, RS2D, RDM, RDW,
    input [2:0]ResultSrcE,
    input RegWW, RegWM, JumpE, BranchE, BFlag, CLK, RegWE, PCSrcReset, MemWM,  //BEWARE!(ACTIVE LOW)
    input [31:0]ALU_ResultE, ALU_ResultM, 
    output reg StallF, StallD, FlushD, FlushE, StallE, FlushM,
    output reg [1:0]ForwardAE, ForwardBE,
    output PCSrcE
);

assign PCSrcE = (JumpE | (BranchE & BFlag)) & PCSrcReset;
reg FlushEQ;
always @(*) begin
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;
    StallF = 1'b0; StallD = 1'b0; FlushEQ = 1'b0; StallE = 1'b0; FlushM = 1'b1;
//Forward from memory and writeback
    if ((RS1E == RDM && RegWM == 1) && RDM != 5'b0) begin
        ForwardAE = 2'b10;
    end
    else if ((RS1E == RDW && RegWW == 1) && RDW != 5'b0)begin
        ForwardAE = 2'b01;
    end
    if ((RS2E == RDM && RegWM == 1) && RDM != 5'b0) begin
        ForwardBE = 2'b10;
    end
    else if ((RS2E == RDW && RegWW == 1) && RDW != 5'b0)begin
        ForwardBE = 2'b01;
    end
//Stall Logic
    if ((((RS1D == RDE) || (RS2D == RDE)) && (RDE != 5'b0)) && ResultSrcE == 3'b000 && RegWE == 1'b1)begin //Mem will write!!
        StallF = 1'b1; StallD = 1'b1; FlushEQ = 1'b1;
    end 

    if ((MemWM == 1) && (ALU_ResultM == ALU_ResultE) && (RegWE == 1 && ResultSrcE == 3'b000)) begin 
        StallF = 1'b1; StallD = 1'b1; StallE = 1'b1; FlushM = 1'b0; FlushEQ = 1'b0;  
    end 

    FlushE = ~(FlushEQ | PCSrcE);
    FlushD = ~PCSrcE;

end

endmodule