`timescale 1ns/1ps
module testbench;
    reg [31:0]TInstruction, TD_PCD, TD_PCPlus4D, TResultW;
    reg [4:0]TRDW;
    reg CLK, RegWW; 
    wire [31:0]PCD, RD1, RD2, ExtImmD, PCPlus4D;
    wire RegWD, MemWD, JumpD, BranchD, ALUSrcD, funct_7_5CD;
    wire [2:0]ResultSrcD, ALU_ControlD;
    wire [4:0]RS1D, RS2D, RDD;
    D DUT(
        .D_Instruction(TInstruction), //32bit input
        .D_PCD(TD_PCD), //32bit
        .D_PCPlus4D(TD_PCPlus4D), //32bit
        .ResultW(TResultW), //32bit
        .RDW(TRDW), //5bit
        .CLK(CLK),
        .RegWW(RegWW), //1bit
        //Input ends here.
        .PCD(PCD), //32bit
        .RD1(RD1), //32bit
        .RD2(RD2), //32bit
        .ExtImmD(ExtImmD), //32bit
        .PCPlus4D(PCPlus4D),//32bit
        .RegWD(RegWD),
        .MemWD(MemWD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .funct_7_5CD(funct_7_5CD),
        .ResultSrcD(ResultSrcD), //3bit
        .ALU_ControlD(ALU_ControlD), //3bit
        .RS1D(RS1D), //5bit
        .RS2D(RS2D), //5bits
        .RDD(RDD)  //5bits
        );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        //$monitor($time, " CLK = %b, PCSrc = %b, Target = %b, curr_PC = %b, MemFetched = %b, PC+4 = %b, stallF = %b", CLK, PCSrc, PCTargetE, PCF, instruction, PCPlus4F, stallF);
        
    end

    initial CLK = 0;
    always #(1) CLK = ~CLK;

    initial begin
        TInstruction = 32'b0;
        TD_PCD = 32'b0; 
        TD_PCPlus4D = 32'b0; 
        TResultW = 32'b0;
        TRDW = 5'b0;
        RegWW = 1'b0;
    end

    task verify_decode(
        input [31:0] instr,
        input        exp_RegWD,
        input        exp_MemWD,
        input        exp_JumpD,
        input        exp_BranchD,
        input        exp_ALUSrcD,
        input [2:0]  exp_ALU_ControlD,
        input [2:0]  exp_ResultSrcD,
        input [4:0]  exp_RS1,
        input [4:0]  exp_RS2,
        input [4:0]  exp_RD,
        input [31:0] exp_RD1,
        input [31:0] exp_RD2,
        input [31:0] exp_imm
    );
        begin
            // 1. Inject the stimulus
            TInstruction = instr;
            
            // 2. Wait for combinational paths to evaluate safely
            #2; 
            
            // 3. Self-Check using case-equality (===) to catch floating 'X' states
            if (RegWD !=? exp_RegWD || MemWD !=? exp_MemWD || JumpD !=? exp_JumpD || 
                BranchD !=? exp_BranchD || ALUSrcD !=? exp_ALUSrcD || 
                ALU_ControlD !=? exp_ALU_ControlD || ResultSrcD !=? exp_ResultSrcD ||
                RS1D !=? exp_RS1 || RS2D !=? exp_RS2 || RDD !=? exp_RD || RD1 !=? exp_RD1 || 
                RD2 !=? exp_RD2 || ExtImmD !=? exp_imm) begin
                
                $display("[FAIL] Instr: %h",instr);
                $display("       Expected: RegWD=%b MemWD=%b JumpD=%b Bch=%b ALUSrc=%b ALU_Ctrl=%b ResSrc=%b RS1=%d RS2=%d RD=%d RD1=%d RD2=%d immext=%d",
                    exp_RegWD, exp_MemWD, exp_JumpD, exp_BranchD, exp_ALUSrcD, exp_ALU_ControlD, exp_ResultSrcD, exp_RS1, exp_RS2, exp_RD, exp_RD1, exp_RD2, exp_imm);
                $display("       Got     : RegWD=%b MemWD=%b JumpD=%b Bch=%b ALUSrc=%b ALU_Ctrl=%b ResSrc=%b RS1=%d RS2=%d RD=%d RD1=%d RD2=%d immext=%d",
                    RegWD, MemWD, JumpD, BranchD, ALUSrcD, ALU_ControlD, ResultSrcD, RS1D, RS2D, RDD, RD1, RD2, ExtImmD);
            end else begin
                $display("[PASS] Instr: %h decoded correctly!", instr);
            end
        end
    endtask

    // --- Main Simulation Sequence ---
    initial begin
        // Initialize lines at time zero
        TInstruction = 32'b0; TD_PCD = 32'b0; TD_PCPlus4D = 32'b0; 
        TResultW = 32'b0; TRDW = 5'b0; RegWW = 1'b0;

        // PHASE 1: Your original Register File Pre-load sequence
        $display("=== Phase 1: Pre-loading Register File ===");
        RegWW = 1'b1; TRDW = 5'b0; TResultW = 32'b0; 
        #2 TRDW = 5'd1;  TResultW = 32'd1;
        #2 TRDW = 5'd2;  TResultW = 32'd2;
        #2 TRDW = 5'd3;  TResultW = 32'd3;
        #2 TRDW = 5'd4;  TResultW = 32'd4;
        #2 TRDW = 5'd5;  TResultW = 32'd5;
        #2 TRDW = 5'd6;  TResultW = 32'd6;
        #2 TRDW = 5'd7;  TResultW = 32'd7;
        #2 TRDW = 5'd8;  TResultW = 32'd8;
        #2 TRDW = 5'd9;  TResultW = 32'd9;
        #2 TRDW = 5'd10; TResultW = 32'd10;
        #2 TRDW = 5'd11; TResultW = 32'd11;
        #2 TRDW = 5'd12; TResultW = 32'd12;
        #2 TRDW = 5'd13; TResultW = 32'd13;
        #2 TRDW = 5'd14; TResultW = 32'd14;
        #2 TRDW = 5'd15; TResultW = 32'd15;
        #2 TRDW = 5'd16; TResultW = 32'd16;
        #2 TRDW = 5'd17; TResultW = 32'd17;
        #2 TRDW = 5'd18; TResultW = 32'd18;
        #2 TRDW = 5'd19; TResultW = 32'd19;
        #2 TRDW = 5'd20; TResultW = 32'd20;
        #2 TRDW = 5'd21; TResultW = 32'd21;
        #2 TRDW = 5'd22; TResultW = 32'd22;
        #2 TRDW = 5'd23; TResultW = 32'd23;
        #2 TRDW = 5'd24; TResultW = 32'd24;
        #2 TRDW = 5'd25; TResultW = 32'd25;
        #2 TRDW = 5'd26; TResultW = 32'd26;
        #2 TRDW = 5'd27; TResultW = 32'd27;
        #2 TRDW = 5'd28; TResultW = 32'd28;
        #2 TRDW = 5'd29; TResultW = 32'd29;
        #2 TRDW = 5'd30; TResultW = 32'd30;
        #2 TRDW = 5'd31; TResultW = 32'd31;
        
        // Turn off write-back so we don't accidentally stomp over registers during decoding tests
        #2 RegWW = 1'b0; TResultW = 32'b0;

        // PHASE 2: Decode Testing using the Task
        $display("\n=== Phase 2: Testing Decode Control Signals ===");
        
        // Example 1: ADD x3, x1, x2 (R-type)
        // Task parameters map: (instr, RegWD, MemWD, JumpD, BranchD, ALUSrcD, ALU_ControlD, ResultSrcD, RS1, RS2, RD, RD1, RD2, imm)

        //lb x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd    RD1    RD2    imm
        verify_decode(32'h00810203, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000, 3'b000, 5'd2, 5'bxxxxx, 5'd4, 32'd2, 32'bx, 32'd8);

        //lh x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00811203, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000, 3'b000, 5'd2, 5'bxxxxx, 5'd4, 32'd2, 32'bx, 32'd8);

        //lw x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00812203, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000, 3'b000, 5'd2, 5'bxxxxx, 5'd4, 32'd2, 32'bx, 32'd8);

        //lbu x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00814203, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000, 3'b000, 5'd2, 5'bxxxxx, 5'd4, 32'd2, 32'bx, 32'd8);

        //lhu x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00815203, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000, 3'b000, 5'd2, 5'bxxxxx, 5'd4, 32'd2, 32'bx, 32'd8);

        //sb x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00410423, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 3'b000, 3'bxxx, 5'd2, 5'd4, 5'bxxxxx, 32'd2, 32'bx, 32'd8);

        //sh x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd
        verify_decode(32'h00411423, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 3'b000, 3'bxxx, 5'd2, 5'd4, 5'bxxxxx, 32'd2, 32'bx, 32'd8);

        //sw x4, 8(x2)   //ins      regw    mw   jd    bd   asrc  actrl    rsrc   rs1    rs2       rd    RD1    RD2     Imm
        verify_decode(32'h00412423, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 3'b000, 3'bxxx, 5'd2, 5'd4, 5'bxxxxx, 32'd2, 32'bx, 32'd8);

        //jal x1,16;
        verify_decode(32'h010000EF, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 3'bxxx, 3'b101, 5'bxxxxx, 5'bxxxxx, 5'd1, 32'bx, 32'bx, 32'd16);

        //jalr x1, 8(x2)
        verify_decode(32'h008100E7, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 3'b000, 3'b101, 5'd2, 5'bxxxxx, 5'd1, 32'd2, 32'bx, 32'd8);

        //beq x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h00208463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //bne x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h00209463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //blt x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h0020C463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //bge x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h0020D463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //bltu x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h0020E463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //bgeu x1, x2, 8   instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'h0020F463, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 3'bxxx, 3'bxxx, 5'd1, 5'd2, 5'bxxxxx, 32'd1, 32'bx, 32'd8);

        //ILLEGAL        instr     regw   mw    jd    bd   asrc   actrl   rsrc    rs1   rs2    rd
        verify_decode(32'hffffffff, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 3'b000, 3'bxxx, 5'bxxxxx, 5'bxxxxx, 5'bxxxxx, 32'bx, 32'bx, 32'bx);

        #10;
        $display("All explicit directed tests completed.");
        $finish;
    end

endmodule