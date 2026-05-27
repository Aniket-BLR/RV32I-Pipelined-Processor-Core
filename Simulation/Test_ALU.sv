`timescale 1s/100ms
module alu_testbench;
  // reg [31:0]RS1, RS2;
  // reg[2:0]Control;
  // wire [31:0]resultasauraus;
  // reg CLK, funct_3_0, funct_3_2, funct_7_5;
  // ALU DUT( 
  //   .A(RS1), 
  //   .B(RS2), 
  //   .ALU_Control(Control), 
  //   .ALU_Result(resultasauraus), 
  //   .funct_3_0(funct_3_0),
  //   .funct_3_2(funct_3_2),
  //   .funct_7_5(funct_7_5)
  //   );

  // initial begin
  //   $dumpfile("wave.vcd");
  //   $dumpvars(0, testbench);

  //   $monitor($time, " A = %b, B = %b, Result = %b Control = %b, funct3[0] = %b", RS1, RS2, resultasauraus, Control, funct_3_0);
  // end

  // initial CLK = 0;
  // always #(1) CLK = ~CLK;

  // initial begin
  //   RS1 = 32'b0;
  //   RS2 = 32'b0;
  //   Control = 3'b111;
  //   funct_3_0 = 0;
  //   funct_3_2 = 0;
  //   funct_7_5 = 0;
  // end

  // initial begin
  //   #2; //2s System stabilizes.
  //   #1 Control = 3'b110;
  //   #1 RS1 = 32'h80000000; RS2 = 32'd31;
  //   #1 funct_3_0 = 1'b0; funct_3_2 = 1'b0; funct_7_5 = 1'b1;
  //   #1 funct_3_0 = 1'b0; funct_3_2 = 1'b1; funct_7_5 = 1'b0;
  //   #1 funct_3_0 = 1'b0; funct_3_2 = 1'b1; funct_7_5 = 1'b1;
  //   #1 funct_3_0 = 1'b1; funct_3_2 = 1'b0; funct_7_5 = 1'b0;
  //   #1 funct_3_0 = 1'b1; funct_3_2 = 1'b0; funct_7_5 = 1'b1;
  //   #1 funct_3_0 = 1'b1; funct_3_2 = 1'b1; funct_7_5 = 1'b0;
  //   #1 funct_3_0 = 1'b1; funct_3_2 = 1'b1; funct_7_5 = 1'b1;
  //   #2 $finish;
  // end

  reg [31:0]write;
  reg Load_cmd, CLK, Flush, tFlush, tLoad_cmd;
  wire [31:0]read, tread;
  Bit32PIPORegister DUT( 
    .write(write),
    .Load_cmd(Load_cmd),
    .CLK(CLK), 
    .Flush(Flush),
    .read(tread)
    );

  Bit32PIPORegister DUT2( 
    .write(tread),
    .Load_cmd(tLoad_cmd),
    .CLK(CLK), 
    .Flush(tFlush),
    .read(read)
    );

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, alu_testbench);

    $monitor("CLK: %b, Load_cmd: %b, write: %d, read: %d, Flush: %b, tread = %b",CLK, Load_cmd, write, read, Flush, tread);
  end

  initial CLK = 0;
  always #(1) CLK = ~CLK;

  initial begin
    write = 32'd0;
    Load_cmd = 1;
    Flush = 1'b1; 
    tLoad_cmd = 1;
    tFlush = 1'b1;
  end

  initial begin
    #2; //2s System stabilizes
    #1 write = 32'd6;
    #2 write = 32'd5; Flush = 1'b0;
    #2 write = 32'd4; Flush = 1'b1;
    #4 $finish;
  end
endmodule