/*
CONTAINS:
1)DLatch 2)DFlipFlopPosedge 3)MUX, Decoder, Reader.
*/
`timescale 1ns/1ps
module DLatch ( //Active Low Set Reset.
    input D, S, R, CLK,
    output Q, Qn
);

// wire t1, t2;
// assign t1 = ~(~(D & CLK) & Qn);
// assign t2 = ~(~(~D & CLK) & Q);
// assign Q = (t1 | ~S) & R;
// assign Qn = t2 & S;

wire Dd;
assign Dd = (D | ~S) & R;
assign Q = ~(~(Dd & CLK) & Qn);
assign Qn = ~(~(~Dd & CLK) & Q);
    
endmodule

module DFlipFlopPosedge ( //Active Low.
    input D, CLK, S, R,
    output Q, Qn
);

wire Q1, Q2;
DLatch D1(.D(D), .CLK(~CLK), .S(S), .R(R), .Q(Q1), .Qn(Q2));
DLatch D2(.D(Q1), .CLK(CLK), .S(1'b1), .R(1'b1), .Q(Q), .Qn(Qn)); //CHANGED THIS!!!
    
endmodule

module MUX2to1 (
    input [31:0]a, b,
    input s,
    output [31:0] c
);

assign c = s ? a : b; //s == 1 => a else b.
    
endmodule

module Decoder3to8 (
    input [2:0]address, //Read left to right. 
    input en,
    output [7:0]target
);

assign target[7] = (en & address[2] & address[1] & address[0]); //111
assign target[6] = (en & address[2] & address[1] & ~address[0]); //110
assign target[5] = (en & address[2] & ~address[1] & address[0]); //101
assign target[4] = (en & address[2] & ~address[1] & ~address[0]); //100
assign target[3] = (en & ~address[2] & address[1] & address[0]); //011
assign target[2] = (en & ~address[2] & address[1] & ~address[0]); //010
assign target[1] = (en & ~address[2] & ~address[1] & address[0]); //001
assign target[0] = (en & ~address[2] & ~address[1] & ~address[0]); //000
    
endmodule

module Decoder5to32 (
    input [4:0]address,
    input en,
    output [31:0]target
);
wire t0, t1, t2, t3;
assign t0 = (~address[4] & ~address[3]); //00xxx
assign t1 = (~address[4] & address[3]); //01xxx
assign t2 = (address[4] & ~address[3]); //10xxx
assign t3 = (address[4] & address[3]); //11xxx

Decoder3to8 Dec1(.address(address[2:0]), .en(t0), .target(target[7:0]));
Decoder3to8 Dec2(.address(address[2:0]), .en(t1), .target(target[15:8]));
Decoder3to8 Dec3(.address(address[2:0]), .en(t2), .target(target[23:16]));
Decoder3to8 Dec4(.address(address[2:0]), .en(t3), .target(target[31:24]));
    
endmodule

module ReaderTree (
    input [4:0]control,
    input [31:0]databuses [31:0],
    output [31:0]data
);

wire [31:0]t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29, t30;
MUX2to1 L1_0 (.b(databuses[0]), .a(databuses[1]), .s(control[0]), .c(t0));
MUX2to1 L1_1 (.b(databuses[2]), .a(databuses[3]), .s(control[0]), .c(t1));
MUX2to1 L1_2 (.b(databuses[4]), .a(databuses[5]), .s(control[0]), .c(t2));
MUX2to1 L1_3 (.b(databuses[6]), .a(databuses[7]), .s(control[0]), .c(t3));
MUX2to1 L1_4 (.b(databuses[8]), .a(databuses[9]), .s(control[0]), .c(t4));
MUX2to1 L1_5 (.b(databuses[10]), .a(databuses[11]), .s(control[0]), .c(t5));
MUX2to1 L1_6 (.b(databuses[12]), .a(databuses[13]), .s(control[0]), .c(t6));
MUX2to1 L1_7 (.b(databuses[14]), .a(databuses[15]), .s(control[0]), .c(t7));
MUX2to1 L1_8 (.b(databuses[16]), .a(databuses[17]), .s(control[0]), .c(t8));
MUX2to1 L1_9 (.b(databuses[18]), .a(databuses[19]), .s(control[0]), .c(t9));
MUX2to1 L1_10 (.b(databuses[20]), .a(databuses[21]), .s(control[0]), .c(t10));
MUX2to1 L1_11 (.b(databuses[22]), .a(databuses[23]), .s(control[0]), .c(t11));
MUX2to1 L1_12 (.b(databuses[24]), .a(databuses[25]), .s(control[0]), .c(t12));
MUX2to1 L1_13 (.b(databuses[26]), .a(databuses[27]), .s(control[0]), .c(t13));
MUX2to1 L1_14 (.b(databuses[28]), .a(databuses[29]), .s(control[0]), .c(t14));
MUX2to1 L1_15 (.b(databuses[30]), .a(databuses[31]), .s(control[0]), .c(t15));

MUX2to1 L2_0 (.b(t0), .a(t1), .s(control[1]), .c(t16));
MUX2to1 L2_1 (.b(t2), .a(t3), .s(control[1]), .c(t17));
MUX2to1 L2_2 (.b(t4), .a(t5), .s(control[1]), .c(t18));
MUX2to1 L2_3 (.b(t6), .a(t7), .s(control[1]), .c(t19));
MUX2to1 L2_4 (.b(t8), .a(t9), .s(control[1]), .c(t20));
MUX2to1 L2_5 (.b(t10), .a(t11), .s(control[1]), .c(t21));
MUX2to1 L2_6 (.b(t12), .a(t13), .s(control[1]), .c(t22));
MUX2to1 L2_7 (.b(t14), .a(t15), .s(control[1]), .c(t23));

MUX2to1 L3_0 (.b(t16), .a(t17), .s(control[2]), .c(t24));
MUX2to1 L3_1 (.b(t18), .a(t19), .s(control[2]), .c(t25));
MUX2to1 L3_2 (.b(t20), .a(t21), .s(control[2]), .c(t26));
MUX2to1 L3_3 (.b(t22), .a(t23), .s(control[2]), .c(t27));

MUX2to1 L4_0 (.b(t24), .a(t25), .s(control[3]), .c(t28));
MUX2to1 L4_1 (.b(t26), .a(t27), .s(control[3]), .c(t29));

MUX2to1 L5_0 (.b(t28), .a(t29), .s(control[4]), .c(t30));

assign data = t30;
    
endmodule