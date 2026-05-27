`timescale 1ns/1ps
module OneBitFullAdder (
    input S0, S1, Cin,
    output Cout, R
);

assign R = Cin ^ S0 ^ S1;
assign Cout = (S0 & S1) + | (Cin & (S0 ^ S1));
    
endmodule

module FullAdder32Bits ( 
    input [31:0]Op1, Op2,
    input Cin,
    output Cout, CinMSB,
    output [31:0]R
);

wire [32:0]carry;
assign carry[0] = Cin;

genvar i;
generate
    for (i = 0; i < 32 ; i = i + 1) begin : FA_Loop 
        OneBitFullAdder FA(.S0(Op1[i]), .S1(Op2[i]), .Cin(carry[i]), .Cout(carry[i + 1]), .R(R[i]));
    end
endgenerate

assign CinMSB = carry[31];
assign Cout = carry[32];
    
endmodule