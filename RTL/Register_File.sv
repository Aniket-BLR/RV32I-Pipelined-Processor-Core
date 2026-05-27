/*
This is gonna be our first ever module belonging to the RISC-V Processor.
It's gonna contain, the register file. 
INPUT PORTS: A1, A2, A3, WD, CLK, Reg_Write. (Only WD is 32 bit, data. Rest are just addresses.)
OUTPUT PORTS: RS1, RS2 (This contains the whole 32 Bit value.)
*/
`timescale 1ns/1ps
module RegisterFile (
    input [4:0]A1, A2, A3,
    input [31:0]WD,
    input CLK, Reg_W, Reset_Reg_File,
    output [31:0]RS1, RS2
);

wire [31:0]out_decoder;
wire [31:0]out_reader [31:0];
Decoder5to32 Dec_Reg_File(.address(A3), .en(1'b1), .target(out_decoder));

ZeroReg32Bits x0(.write(WD), .Load_cmd(out_decoder[0] & Reg_W), .CLK(CLK), .read(out_reader[0])); //Special x0. Stays zero always. 
Bit32PIPORegister x1 (.write(WD), .Load_cmd(out_decoder[1] & Reg_W), .CLK(CLK), .read(out_reader[1]), .Flush(Reset_Reg_File));
Bit32PIPORegister x2 (.write(WD), .Load_cmd(out_decoder[2] & Reg_W), .CLK(CLK), .read(out_reader[2]), .Flush(Reset_Reg_File));
Bit32PIPORegister x3 (.write(WD), .Load_cmd(out_decoder[3] & Reg_W), .CLK(CLK), .read(out_reader[3]), .Flush(Reset_Reg_File));
Bit32PIPORegister x4 (.write(WD), .Load_cmd(out_decoder[4] & Reg_W), .CLK(CLK), .read(out_reader[4]), .Flush(Reset_Reg_File));
Bit32PIPORegister x5 (.write(WD), .Load_cmd(out_decoder[5] & Reg_W), .CLK(CLK), .read(out_reader[5]), .Flush(Reset_Reg_File));
Bit32PIPORegister x6 (.write(WD), .Load_cmd(out_decoder[6] & Reg_W), .CLK(CLK), .read(out_reader[6]), .Flush(Reset_Reg_File));
Bit32PIPORegister x7 (.write(WD), .Load_cmd(out_decoder[7] & Reg_W), .CLK(CLK), .read(out_reader[7]), .Flush(Reset_Reg_File));
Bit32PIPORegister x8 (.write(WD), .Load_cmd(out_decoder[8] & Reg_W), .CLK(CLK), .read(out_reader[8]), .Flush(Reset_Reg_File));
Bit32PIPORegister x9 (.write(WD), .Load_cmd(out_decoder[9] & Reg_W), .CLK(CLK), .read(out_reader[9]), .Flush(Reset_Reg_File));
Bit32PIPORegister x10(.write(WD), .Load_cmd(out_decoder[10] & Reg_W), .CLK(CLK), .read(out_reader[10]), .Flush(Reset_Reg_File));
Bit32PIPORegister x11(.write(WD), .Load_cmd(out_decoder[11] & Reg_W), .CLK(CLK), .read(out_reader[11]), .Flush(Reset_Reg_File));
Bit32PIPORegister x12(.write(WD), .Load_cmd(out_decoder[12] & Reg_W), .CLK(CLK), .read(out_reader[12]), .Flush(Reset_Reg_File));
Bit32PIPORegister x13(.write(WD), .Load_cmd(out_decoder[13] & Reg_W), .CLK(CLK), .read(out_reader[13]), .Flush(Reset_Reg_File));
Bit32PIPORegister x14(.write(WD), .Load_cmd(out_decoder[14] & Reg_W), .CLK(CLK), .read(out_reader[14]), .Flush(Reset_Reg_File));
Bit32PIPORegister x15(.write(WD), .Load_cmd(out_decoder[15] & Reg_W), .CLK(CLK), .read(out_reader[15]), .Flush(Reset_Reg_File));
Bit32PIPORegister x16(.write(WD), .Load_cmd(out_decoder[16] & Reg_W), .CLK(CLK), .read(out_reader[16]), .Flush(Reset_Reg_File));
Bit32PIPORegister x17(.write(WD), .Load_cmd(out_decoder[17] & Reg_W), .CLK(CLK), .read(out_reader[17]), .Flush(Reset_Reg_File));
Bit32PIPORegister x18(.write(WD), .Load_cmd(out_decoder[18] & Reg_W), .CLK(CLK), .read(out_reader[18]), .Flush(Reset_Reg_File));
Bit32PIPORegister x19(.write(WD), .Load_cmd(out_decoder[19] & Reg_W), .CLK(CLK), .read(out_reader[19]), .Flush(Reset_Reg_File));
Bit32PIPORegister x20(.write(WD), .Load_cmd(out_decoder[20] & Reg_W), .CLK(CLK), .read(out_reader[20]), .Flush(Reset_Reg_File));
Bit32PIPORegister x21(.write(WD), .Load_cmd(out_decoder[21] & Reg_W), .CLK(CLK), .read(out_reader[21]), .Flush(Reset_Reg_File));
Bit32PIPORegister x22(.write(WD), .Load_cmd(out_decoder[22] & Reg_W), .CLK(CLK), .read(out_reader[22]), .Flush(Reset_Reg_File));
Bit32PIPORegister x23(.write(WD), .Load_cmd(out_decoder[23] & Reg_W), .CLK(CLK), .read(out_reader[23]), .Flush(Reset_Reg_File));
Bit32PIPORegister x24(.write(WD), .Load_cmd(out_decoder[24] & Reg_W), .CLK(CLK), .read(out_reader[24]), .Flush(Reset_Reg_File));
Bit32PIPORegister x25(.write(WD), .Load_cmd(out_decoder[25] & Reg_W), .CLK(CLK), .read(out_reader[25]), .Flush(Reset_Reg_File));
Bit32PIPORegister x26(.write(WD), .Load_cmd(out_decoder[26] & Reg_W), .CLK(CLK), .read(out_reader[26]), .Flush(Reset_Reg_File));
Bit32PIPORegister x27(.write(WD), .Load_cmd(out_decoder[27] & Reg_W), .CLK(CLK), .read(out_reader[27]), .Flush(Reset_Reg_File));
Bit32PIPORegister x28(.write(WD), .Load_cmd(out_decoder[28] & Reg_W), .CLK(CLK), .read(out_reader[28]), .Flush(Reset_Reg_File));
Bit32PIPORegister x29(.write(WD), .Load_cmd(out_decoder[29] & Reg_W), .CLK(CLK), .read(out_reader[29]), .Flush(Reset_Reg_File));
Bit32PIPORegister x30(.write(WD), .Load_cmd(out_decoder[30] & Reg_W), .CLK(CLK), .read(out_reader[30]), .Flush(Reset_Reg_File));
Bit32PIPORegister x31(.write(WD), .Load_cmd(out_decoder[31] & Reg_W), .CLK(CLK), .read(out_reader[31]), .Flush(Reset_Reg_File));

ReaderTree R1_Reg_File(.control(A1), .databuses(out_reader), .data(RS1));
ReaderTree R2_Reg_File(.control(A2), .databuses(out_reader), .data(RS2));
    
endmodule