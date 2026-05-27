`timescale 1s/100ms
module regfile_testbench;
  reg [4:0]A1, A2, A3;
  reg [31:0]data;
  reg CLK, Reg_Write, Reset;
  wire [31:0]RS1, RS2; 
  RegisterFile DUT(.A1(A1), .A2(A2), .A3(A3), .WD(data), .CLK(CLK), .Reg_W(Reg_Write), .Reset_Reg_File(Reset), .RS1(RS1), .RS2(RS2));

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, regfile_testbench);

    $monitor($time, " CLK = %b, A1 = %b, A2 = %b, A3 = %b, Data = %b, Write? = %b", CLK, A1, A2, A3, data, Reg_Write);
    $monitor($time, " OUTPUT, RS1 = %b, RS2 = %b", RS1, RS2);
  end

  initial CLK = 0;
  always #(1) CLK = ~CLK;

  initial begin
    Reset = 0;
    A1 = 5'b00000;
    A2 = 5'b00000;
    A3 = 5'b00000;
    data = 32'b00000000000000000000000000000000;
    Reg_Write = 0;
  end

  initial begin
    #2 Reset = 1; //2s
    #2; //4s Let the signals stabilize.
    #1 Reg_Write = 1; //5s
    #1 data = 32'b00000000000000000000000000000001; //6s
    #0.5 A3 = 5'b00011; //6.5s
    #0 A1 = 5'b00011;
    #1 A2 = 5'b00011; //8s
    #1 Reg_Write = 0;
    #2 Reset = 0;
    #2 Reset = 1;
    #4 $finish;
  end
endmodule