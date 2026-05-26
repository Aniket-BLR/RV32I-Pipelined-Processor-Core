`timescale 1ns/1ps
//Crudely written, but ok. I have all the types of registers I'll ever need here. 

module PIPORegisterUnit (
    input W, Ws, CLK, Reset,
    output R
);

wire D;
assign D = Ws ? W : R;
DFlipFlopPosedge D1(.D(D), .CLK(CLK), .S(1'b1), .R(Reset), .Q(R));
    
endmodule

module PIPOZeroRegisterUnit (
    input W, Ws, CLK, 
    output R
);

wire t1, t2, D;
assign t2 = 1'b0;
assign t1 = W & 1'b0;
assign D = Ws ? t1 : t2;
DFlipFlopPosedge D1(.D(D), .CLK(CLK), .S(1'b1), .R(1'b1), .Q(R));
    
endmodule

module Bit32PIPORegister ( //Active Low flushing
    input [31:0]write,
    input Load_cmd, CLK, Flush,
    output [31:0]read
);

PIPORegisterUnit P1 (.W(write[31]), .Ws(Load_cmd), .CLK(CLK), .R(read[31]), .Reset(Flush));
PIPORegisterUnit P2 (.W(write[30]), .Ws(Load_cmd), .CLK(CLK), .R(read[30]), .Reset(Flush));
PIPORegisterUnit P3 (.W(write[29]), .Ws(Load_cmd), .CLK(CLK), .R(read[29]), .Reset(Flush));
PIPORegisterUnit P4 (.W(write[28]), .Ws(Load_cmd), .CLK(CLK), .R(read[28]), .Reset(Flush));
PIPORegisterUnit P5 (.W(write[27]), .Ws(Load_cmd), .CLK(CLK), .R(read[27]), .Reset(Flush));
PIPORegisterUnit P6 (.W(write[26]), .Ws(Load_cmd), .CLK(CLK), .R(read[26]), .Reset(Flush));
PIPORegisterUnit P7 (.W(write[25]), .Ws(Load_cmd), .CLK(CLK), .R(read[25]), .Reset(Flush));
PIPORegisterUnit P8 (.W(write[24]), .Ws(Load_cmd), .CLK(CLK), .R(read[24]), .Reset(Flush));
PIPORegisterUnit P9 (.W(write[23]), .Ws(Load_cmd), .CLK(CLK), .R(read[23]), .Reset(Flush));

PIPORegisterUnit P10 (.W(write[22]), .Ws(Load_cmd), .CLK(CLK), .R(read[22]), .Reset(Flush));
PIPORegisterUnit P11 (.W(write[21]), .Ws(Load_cmd), .CLK(CLK), .R(read[21]), .Reset(Flush));
PIPORegisterUnit P12 (.W(write[20]), .Ws(Load_cmd), .CLK(CLK), .R(read[20]), .Reset(Flush));
PIPORegisterUnit P13 (.W(write[19]), .Ws(Load_cmd), .CLK(CLK), .R(read[19]), .Reset(Flush));
PIPORegisterUnit P14 (.W(write[18]), .Ws(Load_cmd), .CLK(CLK), .R(read[18]), .Reset(Flush));
PIPORegisterUnit P15 (.W(write[17]), .Ws(Load_cmd), .CLK(CLK), .R(read[17]), .Reset(Flush));
PIPORegisterUnit P16 (.W(write[16]), .Ws(Load_cmd), .CLK(CLK), .R(read[16]), .Reset(Flush));
PIPORegisterUnit P17 (.W(write[15]), .Ws(Load_cmd), .CLK(CLK), .R(read[15]), .Reset(Flush));
PIPORegisterUnit P18 (.W(write[14]), .Ws(Load_cmd), .CLK(CLK), .R(read[14]), .Reset(Flush));
PIPORegisterUnit P19 (.W(write[13]), .Ws(Load_cmd), .CLK(CLK), .R(read[13]), .Reset(Flush));
PIPORegisterUnit P20 (.W(write[12]), .Ws(Load_cmd), .CLK(CLK), .R(read[12]), .Reset(Flush));
PIPORegisterUnit P21 (.W(write[11]), .Ws(Load_cmd), .CLK(CLK), .R(read[11]), .Reset(Flush));
PIPORegisterUnit P22 (.W(write[10]), .Ws(Load_cmd), .CLK(CLK), .R(read[10]), .Reset(Flush));

PIPORegisterUnit P23 (.W(write[9]), .Ws(Load_cmd), .CLK(CLK), .R(read[9]), .Reset(Flush));
PIPORegisterUnit P24 (.W(write[8]), .Ws(Load_cmd), .CLK(CLK), .R(read[8]), .Reset(Flush));
PIPORegisterUnit P25 (.W(write[7]), .Ws(Load_cmd), .CLK(CLK), .R(read[7]), .Reset(Flush));
PIPORegisterUnit P26 (.W(write[6]), .Ws(Load_cmd), .CLK(CLK), .R(read[6]), .Reset(Flush));
PIPORegisterUnit P27 (.W(write[5]), .Ws(Load_cmd), .CLK(CLK), .R(read[5]), .Reset(Flush));
PIPORegisterUnit P28 (.W(write[4]), .Ws(Load_cmd), .CLK(CLK), .R(read[4]), .Reset(Flush));
PIPORegisterUnit P29 (.W(write[3]), .Ws(Load_cmd), .CLK(CLK), .R(read[3]), .Reset(Flush));
PIPORegisterUnit P30 (.W(write[2]), .Ws(Load_cmd), .CLK(CLK), .R(read[2]), .Reset(Flush));
PIPORegisterUnit P31 (.W(write[1]), .Ws(Load_cmd), .CLK(CLK), .R(read[1]), .Reset(Flush));
PIPORegisterUnit P32 (.W(write[0]), .Ws(Load_cmd), .CLK(CLK), .R(read[0]), .Reset(Flush));
    
endmodule

module Bit5PIPORegister ( //Active Low flushing
    input [4:0]write,
    input Load_cmd, CLK, Flush,
    output [4:0]read
);

PIPORegisterUnit P5_1 (.W(write[4]), .Ws(Load_cmd), .CLK(CLK), .R(read[4]), .Reset(Flush));
PIPORegisterUnit P5_2 (.W(write[3]), .Ws(Load_cmd), .CLK(CLK), .R(read[3]), .Reset(Flush));
PIPORegisterUnit P5_3 (.W(write[2]), .Ws(Load_cmd), .CLK(CLK), .R(read[2]), .Reset(Flush));
PIPORegisterUnit P5_4 (.W(write[1]), .Ws(Load_cmd), .CLK(CLK), .R(read[1]), .Reset(Flush));
PIPORegisterUnit P5_5 (.W(write[0]), .Ws(Load_cmd), .CLK(CLK), .R(read[0]), .Reset(Flush));
    
endmodule

module Bit3PIPORegister ( //Active Low flushing
    input [2:0]write,
    input Load_cmd, CLK, Flush,
    output [2:0]read
);

PIPORegisterUnit P3_1 (.W(write[2]), .Ws(Load_cmd), .CLK(CLK), .R(read[2]), .Reset(Flush));
PIPORegisterUnit P3_2 (.W(write[1]), .Ws(Load_cmd), .CLK(CLK), .R(read[1]), .Reset(Flush));
PIPORegisterUnit P3_3 (.W(write[0]), .Ws(Load_cmd), .CLK(CLK), .R(read[0]), .Reset(Flush));
    
endmodule

module ZeroReg32Bits (
    input [31:0]write,
    input Load_cmd, CLK,
    output [31:0]read
);

PIPOZeroRegisterUnit Z1 (.W(write[31]), .Ws(Load_cmd), .CLK(CLK), .R(read[31]));
PIPOZeroRegisterUnit Z2 (.W(write[30]), .Ws(Load_cmd), .CLK(CLK), .R(read[30]));
PIPOZeroRegisterUnit Z3 (.W(write[29]), .Ws(Load_cmd), .CLK(CLK), .R(read[29]));
PIPOZeroRegisterUnit Z4 (.W(write[28]), .Ws(Load_cmd), .CLK(CLK), .R(read[28]));
PIPOZeroRegisterUnit Z5 (.W(write[27]), .Ws(Load_cmd), .CLK(CLK), .R(read[27]));
PIPOZeroRegisterUnit Z6 (.W(write[26]), .Ws(Load_cmd), .CLK(CLK), .R(read[26]));
PIPOZeroRegisterUnit Z7 (.W(write[25]), .Ws(Load_cmd), .CLK(CLK), .R(read[25]));
PIPOZeroRegisterUnit Z8 (.W(write[24]), .Ws(Load_cmd), .CLK(CLK), .R(read[24]));
PIPOZeroRegisterUnit Z9 (.W(write[23]), .Ws(Load_cmd), .CLK(CLK), .R(read[23]));

PIPOZeroRegisterUnit Z10 (.W(write[22]), .Ws(Load_cmd), .CLK(CLK), .R(read[22]));
PIPOZeroRegisterUnit Z11 (.W(write[21]), .Ws(Load_cmd), .CLK(CLK), .R(read[21]));
PIPOZeroRegisterUnit Z12 (.W(write[20]), .Ws(Load_cmd), .CLK(CLK), .R(read[20]));
PIPOZeroRegisterUnit Z13 (.W(write[19]), .Ws(Load_cmd), .CLK(CLK), .R(read[19]));
PIPOZeroRegisterUnit Z14 (.W(write[18]), .Ws(Load_cmd), .CLK(CLK), .R(read[18]));
PIPOZeroRegisterUnit Z15 (.W(write[17]), .Ws(Load_cmd), .CLK(CLK), .R(read[17]));
PIPOZeroRegisterUnit Z16 (.W(write[16]), .Ws(Load_cmd), .CLK(CLK), .R(read[16]));
PIPOZeroRegisterUnit Z17 (.W(write[15]), .Ws(Load_cmd), .CLK(CLK), .R(read[15]));
PIPOZeroRegisterUnit Z18 (.W(write[14]), .Ws(Load_cmd), .CLK(CLK), .R(read[14]));
PIPOZeroRegisterUnit Z19 (.W(write[13]), .Ws(Load_cmd), .CLK(CLK), .R(read[13]));
PIPOZeroRegisterUnit Z20 (.W(write[12]), .Ws(Load_cmd), .CLK(CLK), .R(read[12]));
PIPOZeroRegisterUnit Z21 (.W(write[11]), .Ws(Load_cmd), .CLK(CLK), .R(read[11]));
PIPOZeroRegisterUnit Z22 (.W(write[10]), .Ws(Load_cmd), .CLK(CLK), .R(read[10]));

PIPOZeroRegisterUnit Z23 (.W(write[9]), .Ws(Load_cmd), .CLK(CLK), .R(read[9]));
PIPOZeroRegisterUnit Z24 (.W(write[8]), .Ws(Load_cmd), .CLK(CLK), .R(read[8]));
PIPOZeroRegisterUnit Z25 (.W(write[7]), .Ws(Load_cmd), .CLK(CLK), .R(read[7]));
PIPOZeroRegisterUnit Z26 (.W(write[6]), .Ws(Load_cmd), .CLK(CLK), .R(read[6]));
PIPOZeroRegisterUnit Z27 (.W(write[5]), .Ws(Load_cmd), .CLK(CLK), .R(read[5]));
PIPOZeroRegisterUnit Z28 (.W(write[4]), .Ws(Load_cmd), .CLK(CLK), .R(read[4]));
PIPOZeroRegisterUnit Z29 (.W(write[3]), .Ws(Load_cmd), .CLK(CLK), .R(read[3]));
PIPOZeroRegisterUnit Z30 (.W(write[2]), .Ws(Load_cmd), .CLK(CLK), .R(read[2]));
PIPOZeroRegisterUnit Z31 (.W(write[1]), .Ws(Load_cmd), .CLK(CLK), .R(read[1]));
PIPOZeroRegisterUnit Z32 (.W(write[0]), .Ws(Load_cmd), .CLK(CLK), .R(read[0]));
    
endmodule