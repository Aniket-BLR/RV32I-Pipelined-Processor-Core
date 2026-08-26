`timescale 1ns/1ps
module cpu_testbench;
    reg CLK, PReset;
    reg [31:0] cycle_count;

    RV32I_Processor_Core Processor(.CLK(CLK), .ProcessorReset(PReset));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu_testbench);
    end

    initial CLK = 0;
    always #(1) CLK = ~CLK;

    initial begin
        PReset = 1'b0; 
        // cycle_count = 0;
    end

    // always @(posedge CLK) begin
    //     if (PReset == 0) begin
    //         cycle_count <= 0;
    //     end else begin
    //         cycle_count <= cycle_count + 1;
    //     end
    // end

    // reg [31:0] PCTrack = 32'b0;
    // reg track = 1'b0;

    // task verify_processor(
    //     reg [31:0] exp_x0,
    //     reg [31:0] exp_x1,
    //     reg [31:0] exp_x2,
    //     reg [31:0] exp_x3,
    //     reg [31:0] exp_x4,
    //     reg [31:0] exp_x5,
    //     reg [31:0] exp_x6,
    //     reg [31:0] exp_x7,
    //     reg [31:0] exp_x8,
    //     reg [31:0] exp_x9,
    //     reg [31:0] exp_x10
    // );
    //     if (Processor.tinstruction_F_IFB == 32'h00000063) begin
    //         PCTrack = Processor.tPCPlus4_F_IFB;
    //         track = 1'b1;
    //     end

    //     if (Processor.tPCPlus4_W == PCTrack && track == 1) begin
    //         PReset = 1'b0;
    //         if (Processor.DecodeStage.RF_D.x0.read !=? exp_x0 ||
    //             Processor.DecodeStage.RF_D.x1.read !=? exp_x1 ||
    //             Processor.DecodeStage.RF_D.x2.read !=? exp_x2 ||
    //             Processor.DecodeStage.RF_D.x3.read !=? exp_x3 ||
    //             Processor.DecodeStage.RF_D.x4.read !=? exp_x4 ||
    //             Processor.DecodeStage.RF_D.x5.read !=? exp_x5 ||
    //             Processor.DecodeStage.RF_D.x6.read !=? exp_x6 ||
    //             Processor.DecodeStage.RF_D.x7.read !=? exp_x7 ||
    //             Processor.DecodeStage.RF_D.x8.read !=? exp_x8 ||
    //             Processor.DecodeStage.RF_D.x9.read !=? exp_x9 ||
    //             Processor.DecodeStage.RF_D.x10.read !=? exp_x10) begin
    //                 $display("==FAILED!!==");
    //                 $display("Expected: x0: %d, x1: %d, x2: %d, x3: %d, x4: %d, x5: %d, x6: %d, x7: %d, x8: %d, x9: %d, x10: %d", 
    //                 exp_x0, exp_x1, exp_x2, exp_x3, exp_x4, exp_x5, exp_x6, exp_x7, exp_x8, exp_x9, exp_x10);
    //                 $display("Got:     x0: %d, x1: %d, x2: %d, x3: %d, x4: %d, x5: %d, x6: %d, x7: %d, x8: %d, x9: %d, x10: %d", 
    //                 Processor.DecodeStage.RF_D.x0.read, Processor.DecodeStage.RF_D.x1.read, Processor.DecodeStage.RF_D.x2.read,
    //                 Processor.DecodeStage.RF_D.x3.read, Processor.DecodeStage.RF_D.x4.read, Processor.DecodeStage.RF_D.x5.read,
    //                 Processor.DecodeStage.RF_D.x6.read, Processor.DecodeStage.RF_D.x7.read, Processor.DecodeStage.RF_D.x8.read,
    //                 Processor.DecodeStage.RF_D.x9.read, Processor.DecodeStage.RF_D.x10.read);
    //                 $display("CycleCount: %d", cycle_count);
    //             end
    //         else begin
    //             $display("===SUCCESS!!===");
    //             $display("CycleCount: %d", cycle_count);
    //         end
    //         $finish;
    //     end

    // endtask //automatic

    // always @(posedge CLK) begin
    //     if (PReset == 1) begin
    //         verify_processor(32'bx, 32'b0, 32'd15, 32'bx, 32'bx, 32'bx, 32'bx, 32'bx, 32'bx, 32'bx, 32'bx);
    //     end
    // end

    initial begin
        $display("====STARTING PROGRAM: COUNT TO N NUMBERS====");
        $display("====        AIM: TEST IT ALL       ====");
        #2 PReset = 1'b1;
        #150 $finish;
    end
endmodule