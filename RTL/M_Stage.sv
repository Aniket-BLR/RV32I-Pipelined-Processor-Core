`timescale 1ns/1ps
// The Data Unit is here!
module DataMemory (
    input  wire        CLK,
    input  wire        WE,

    input  wire [31:0] address,
    input  wire [31:0] WriteDataM,
    input  wire [2:0]  funct3M,

    output reg  [31:0] MemRead
);

    // =========================================================
    // BLOCK RAM
    // =========================================================

    (* ram_style = "block" *)
    reg [31:0] datamem [0:255];

    wire [7:0] word_addr;
    wire [1:0] byte_offset;

    assign word_addr  = address[9:2];
    assign byte_offset = address[1:0];

    // =========================================================
    // BYTE ENABLE + WRITE DATA ALIGNMENT
    // =========================================================

    reg [3:0]  byte_we;
    reg [31:0] aligned_write_data;

    always @(*) begin
        byte_we = 4'b0000;
        aligned_write_data = 32'b0;
        case (funct3M)

            // -------------------------------------------------
            // SB
            // -------------------------------------------------

            3'b000: begin
                if (WE) begin
                    byte_we = 4'b0001 << byte_offset;
                    aligned_write_data = WriteDataM << (8 * byte_offset);
                end
            end

            // -------------------------------------------------
            // SH
            // -------------------------------------------------
            3'b001: begin
                if (WE) begin
                    case (byte_offset[1])
                        1'b0: begin
                            byte_we = 4'b0011;
                            aligned_write_data = WriteDataM;
                        end
                        1'b1: begin
                            byte_we = 4'b1100;
                            aligned_write_data = WriteDataM << 16;
                        end
                    endcase
                end
            end

            // -------------------------------------------------
            // SW
            // -------------------------------------------------
            3'b010: begin
                if (WE) begin
                    byte_we = 4'b1111;
                    aligned_write_data = WriteDataM;
                end
            end
            default: begin
                byte_we = 4'b0000;
                aligned_write_data = 32'b0;
            end
        endcase
    end

    // =========================================================
    // BRAM READ/WRITE
    // =========================================================

    reg [31:0] raw_word_read;
    reg [1:0] byte_offset_reg;
    reg [2:0] funct3M_reg;
    always @(posedge CLK) begin
        // -----------------------------------------------------
        // WRITE
        // -----------------------------------------------------
        if (byte_we[0])
            datamem[word_addr][7:0] <= aligned_write_data[7:0];
        if (byte_we[1])
            datamem[word_addr][15:8] <= aligned_write_data[15:8];
        if (byte_we[2])
            datamem[word_addr][23:16] <= aligned_write_data[23:16];
        if (byte_we[3])
            datamem[word_addr][31:24] <= aligned_write_data[31:24];
        // -----------------------------------------------------
        // SYNCHRONOUS READ
        // -----------------------------------------------------
        raw_word_read <= datamem[word_addr];
        // -----------------------------------------------------
        // PIPELINE REGISTERS
        // -----------------------------------------------------
        byte_offset_reg <= byte_offset;
        funct3M_reg <= funct3M;
    end

    // =========================================================
    // LOAD FORMATTER
    // =========================================================

    always @(*) begin
        case (funct3M_reg)
            // -------------------------------------------------
            // LB
            // -------------------------------------------------
            3'b000: begin
                case (byte_offset_reg)
                    2'b00:
                        MemRead = {{24{raw_word_read[7]}},
                                    raw_word_read[7:0]};
                    2'b01:
                        MemRead = {{24{raw_word_read[15]}},
                                    raw_word_read[15:8]};
                    2'b10:
                        MemRead = {{24{raw_word_read[23]}},
                                    raw_word_read[23:16]};
                    2'b11:
                        MemRead = {{24{raw_word_read[31]}},
                                    raw_word_read[31:24]};
                    default:
                        MemRead = 32'b0;
                endcase
            end
            // -------------------------------------------------
            // LH
            // -------------------------------------------------
            3'b001: begin
                if (byte_offset_reg[1])
                    MemRead = {{16{raw_word_read[31]}},
                                raw_word_read[31:16]};
                else
                    MemRead = {{16{raw_word_read[15]}},
                                raw_word_read[15:0]};

            end
            // -------------------------------------------------
            // LW
            // -------------------------------------------------
            3'b010: begin
                MemRead = raw_word_read;
            end
            // -------------------------------------------------
            // LBU
            // -------------------------------------------------
            3'b100: begin
                case (byte_offset_reg)
                    2'b00:
                        MemRead = {24'b0,
                                   raw_word_read[7:0]};
                    2'b01:
                        MemRead = {24'b0,
                                   raw_word_read[15:8]};
                    2'b10:
                        MemRead = {24'b0,
                                   raw_word_read[23:16]};
                    2'b11:
                        MemRead = {24'b0,
                                   raw_word_read[31:24]};
                    default:
                        MemRead = 32'b0;
                endcase
            end
            // -------------------------------------------------
            // LHU
            // -------------------------------------------------
            3'b101: begin
                if (byte_offset_reg[1])
                    MemRead = {16'b0,
                               raw_word_read[31:16]};
                else
                    MemRead = {16'b0,
                               raw_word_read[15:0]};
            end
            default: begin
                MemRead = 32'b0;
            end
        endcase
    end
endmodule

module M_W (
    input [31:0]PCPlus4M, ALU_ResultM, PCTargetM, ExtImmM, MemRead, 
    input [2:0]ResultSrcM, 
    input RegWM, MegaResetM_W, CLK, //BEWARE
    input [4:0]RDM,
    output [4:0]RDW,
    output RegWW,
    output [31:0]PCPlus4W, ALU_ResultW, PCTargetW, ExtImmW, MemReadW, 
    output [2:0]ResultSrcW 
);

Bit32PIPORegister M_W_PCPlus4(.write(PCPlus4M), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(PCPlus4W));
Bit32PIPORegister M_W_ALU_Result(.write(ALU_ResultM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ALU_ResultW));
Bit32PIPORegister M_W_PCTarget(.write(PCTargetM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(PCTargetW));
Bit32PIPORegister M_W_ImmExt(.write(ExtImmM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ExtImmW));
Bit32PIPORegister M_W_MemRead(.write(MemRead), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(MemReadW));

Bit5PIPORegister M_W_RD(.write(RDM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(RDW));

Bit3PIPORegister M_W_ResultSrc(.write(ResultSrcM), .Load_cmd(1'b1), .CLK(CLK), .Flush(MegaResetM_W), .read(ResultSrcW));

PIPORegisterUnit M_W_RegW(.W(RegWM), .Ws(1'b1), .CLK(CLK), .Reset(MegaResetM_W), .R(RegWW));

endmodule