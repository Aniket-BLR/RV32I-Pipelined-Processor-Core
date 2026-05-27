`timescale 1ns/1ps

module ALU (
    input ALU_Sub_Ctrl, funct_7_5,
    input [31:0]A, B,
    input [2:0]ALU_Control,
    output [31:0]ALU_Result,
    output ALU_Flag
);

wire [31:0]r0, r1, r2, r4, r5, r6, r7, t1;
wire Cout, CinMSB, Overflow, U;
wire ef, nef, bgef, bltf, bgeuf, bltuf; //Flags for the B-Type. 

//r0 contains add/sub result. 000.  
assign t1 = ALU_Sub_Ctrl ? ~B : B;
FullAdder32Bits AdderCore_ALU(.Op1(A), .Op2(t1), .Cin(ALU_Sub_Ctrl), .Cout(Cout), .CinMSB(CinMSB), .R(r0));
assign Overflow = Cout ^ CinMSB;

// r2 contains SLT/U. //011 and 010
assign r2[0] = ALU_Control[0] ? ~Cout : (r0[31] ^ Overflow);
assign r2[31:1] = 31'b0;

//r6 contains or results. r7 => AND
assign r6 = (A | B);
assign r7 = (A & B);

//r4 contains xor.
assign r4 = A ^ B; 

//r5 contains SRL/SRLi/SRA/SRAi/SLL/SLLi
assign U = ALU_Control[2] ? funct_7_5 : 1'b0;
wire [31:0]shiftinternal1, shiftinternal1r, number, Ar;
wire [4:0]shiftvalue;

genvar i;
generate
    for (i = 0; i < 32 ;i = i + 1 ) begin
        assign Ar[i] = A[31 - i];
    end
endgenerate

assign number = ALU_Control[2] ? A : Ar;
assign shiftvalue = B[4:0];

ShifterCore S1_ALU(.number(number), .value(shiftvalue), .U(U), .shifted_val(shiftinternal1));

genvar j;
generate
    for (j = 0; j < 32; j = j + 1) begin
        assign shiftinternal1r[j] = shiftinternal1[31 - j];
    end    
endgenerate

assign r1 = shiftinternal1r;
assign r5 = shiftinternal1;

assign bltf = (r0[31] ^ Overflow);
assign bgef = ~bltf;
assign bltuf = ~Cout;
assign bgeuf = ~bltuf;
assign ef = ~|r0;
assign nef = ~ef;

assign ALU_Flag = 
    (ALU_Control == 3'b000) ? ef :
    (ALU_Control == 3'b001) ? nef : 
    (ALU_Control == 3'b100) ? bltf : 
    (ALU_Control == 3'b101) ? bgef :
    (ALU_Control == 3'b110) ? bltuf :
    (ALU_Control == 3'b111) ? bgeuf :
    1'b0;

assign ALU_Result = 
    (ALU_Control == 3'b000) ? r0 :
    (ALU_Control == 3'b001) ? r1 :
    (ALU_Control == 3'b010) ? r2 :
    (ALU_Control == 3'b011) ? r2 :
    (ALU_Control == 3'b100) ? r4 :
    (ALU_Control == 3'b101) ? r5 :
    (ALU_Control == 3'b110) ? r6 :
    (ALU_Control == 3'b111) ? r7 :
    32'b0;
    
endmodule