`timescale 1s/100ms
module shifter_testbench;
  reg [31:0]number;
  reg [4:0]value;
  reg U, CLK;
  wire [31:0]answer;

  ShifterCore DUT(.number(number), .value(value), .U(U), .shifted_val(answer));

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, shifter_testbench);

    $monitor($time, " CLK = %b, U = %b, Value = %b, Shiftedby = %b, Final = %b", CLK, U, number, value, answer);
  end

  initial CLK = 0;
  always #(1) CLK = ~CLK;

  initial begin
    number = 32'b0;
    value = 4'b0;
    U = 0;
  end

  initial begin
    #2 number = 32'b10000000000000000000000000000000;
    #1 value = 4'b1;
    #1 value = 4'b0010;
    #1 value = 4'b0011;
    #1 value = 4'b0100;
    #1 U = 1;
    #1 value = 4'b1;
    #1 value = 4'b0010;
    #1 value = 4'b0011;
    #1 value = 4'b0100;
    #2 $finish;
  end
endmodule