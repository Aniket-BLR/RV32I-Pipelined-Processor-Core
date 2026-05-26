`timescale 1ns/1ps
module testbench;
    reg CLK, PReset;

    RV32I_Processor_Core Processor(.CLK(CLK), .ProcessorReset(PReset));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);
    end

    initial CLK = 0;
    always #(1) CLK = ~CLK;

    initial begin
        PReset = 1'b0; 
    end

    initial begin
        #2 PReset = 1'b1;
        #40 $finish;
    end
endmodule