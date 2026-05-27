`timescale 1ns/1ps
// The Data Unit is here!

//module DataMemory (
//    input [31:0]address, WriteDataM,
//    input [2:0]funct3M,
//    input CLK, WE, 
//    output reg [31:0]MemRead
//);

//reg [7:0] datamem [0:1023];

//always @(posedge CLK) begin
//    if (WE) begin
//        case (funct3M)
//            3'b000: //sb
//            begin
//                datamem[address] <= WriteDataM[7:0];
//            end 

//            3'b001: //sh
//            begin
//                datamem[address] <= WriteDataM[7:0];
//                datamem[address + 1] <= WriteDataM[15:8];
//            end

//            3'b010: //sw
//            begin
//                datamem[address] <= WriteDataM[7:0];
//                datamem[address + 1] <= WriteDataM[15:8];
//                datamem[address + 2] <= WriteDataM[23:16];
//                datamem[address + 3] <= WriteDataM[31:24];
//            end
//        endcase
//    end 

//    case (funct3M)
//        3'b000: //lb
//        begin
//            MemRead <= {{24{datamem[address][7]}}, datamem[address]};
//        end

//        3'b001: //lh
//        begin
//            MemRead <= {{16{datamem[address + 1][7]}}, datamem[address + 1], datamem[address]};
//        end
        
//        3'b010: //lw
//        begin
//            MemRead <= {datamem[address + 3], datamem[address + 2], datamem[address + 1], datamem[address]};
//        end

//        3'b100: //lbu
//        begin
//            MemRead <= {24'b0, datamem[address]};       
//        end

//        3'b101: //lhu
//        begin
//            MemRead <= {16'b0, datamem[address + 1], datamem[address]};
//        end

//        default:
//            MemRead <= 32'b0; 
//    endcase 
//end

//endmodule

// module DataMemory (
//     input CLK,
//     input WE,
//     input [31:0] address,
//     input [31:0] WriteDataM,
//     output [31:0] MemRead, 
//     input [2:0] funct3M
// );

// blk_mem_gen_0 DMEM (
//     .clka(CLK),
//     .ena(1'b1),
//     .wea(WE),
//     .addra(address[11:2]),
//     .dina(WriteDataM),
//     .douta(MemRead)
// );

// endmodule

// module DataMemory (
//     input [31:0] address, WriteDataM,
//     input [2:0] funct3M,
//     input CLK, WE, 
//     output reg [31:0] MemRead
// );

//     // 1024 bytes = 256 words of 32-bits
//     // (* ram_style = "block" *) forces Vivado's hand
//     (* ram_style = "block" *) reg [31:0] datamem [0:255];

//     // Word address is the upper bits. Byte offset is the lower 2 bits.
//     wire [7:0] word_addr = address[9:2];
//     wire [1:0] byte_offset = address[1:0];

//     // ---------------------------------------------------------
//     // WRITE LOGIC (Byte-Steering into 32-bit Word)
//     // ---------------------------------------------------------
//     reg [3:0]  byte_we;
//     reg [31:0] aligned_write_data;

//     always @(*) begin
//         byte_we = 4'b0000;
//         aligned_write_data = 32'b0;
        
//         if (WE) begin
//             case (funct3M)
//                 3'b000: begin // sb
//                     byte_we = 4'b0001 << byte_offset;
//                     aligned_write_data = {4{WriteDataM[7:0]}};
//                 end 
//                 3'b001: begin // sh
//                     // Assumes aligned half-word writes (byte_offset 0 or 2)
//                     byte_we = (byte_offset[1]) ? 4'b1100 : 4'b0011;
//                     aligned_write_data = {2{WriteDataM[15:0]}};
//                 end
//                 3'b010: begin // sw
//                     byte_we = 4'b1111;
//                     aligned_write_data = WriteDataM;
//                 end
//                 default: begin
//                     byte_we = 4'b0000;
//                     aligned_write_data = 32'b0;
//                 end
//             endcase
//         end
//     end

//     // Synchronous Write Process Block RAM
//     always @(posedge CLK) begin
//         if (byte_we[0]) datamem[word_addr][7:0]   <= aligned_write_data[7:0];
//         if (byte_we[1]) datamem[word_addr][15:8]  <= aligned_write_data[15:8];
//         if (byte_we[2]) datamem[word_addr][23:16] <= aligned_write_data[23:16];
//         if (byte_we[3]) datamem[word_addr][31:24] <= aligned_write_data[31:24];
//     end

//     // ---------------------------------------------------------
//     // READ LOGIC (Synchronous Raw Read + Pipelined Formatting)
//     // ---------------------------------------------------------
//     reg [31:0] raw_word_read;
//     reg [1:0]  byte_offset_reg;
//     reg [2:0]  funct3M_reg;

//     // Pure synchronous read to trigger BRAM inference.
//     // We must also pipeline our control signals so they stay in sync with the data.
//     always @(posedge CLK) begin
//         raw_word_read   <= datamem[word_addr];
//         byte_offset_reg <= byte_offset;
//         funct3M_reg     <= funct3M;
//     end

//     // Post-read multiplexing and sign extension (Combines into output reg stage)
//     always @(*) begin
//         case (funct3M_reg)
//             3'b000: begin // lb
//                 case (byte_offset_reg)
//                     2'b00: MemRead = {{24{raw_word_read[7]}},  raw_word_read[7:0]};
//                     2'b01: MemRead = {{24{raw_word_read[15]}}, raw_word_read[15:8]};
//                     2'b10: MemRead = {{24{raw_word_read[23]}}, raw_word_read[23:16]};
//                     2'b11: MemRead = {{24{raw_word_read[31]}}, raw_word_read[31:24]};
//                 endcase
//             end
//             3'b001: begin // lh
//                 if (byte_offset_reg[1])
//                     MemRead = {{16{raw_word_read[31]}}, raw_word_read[31:16]};
//                 else
//                     MemRead = {{16{raw_word_read[15]}}, raw_word_read[15:0]};
//             end
//             3'b010: begin // lw
//                 MemRead = raw_word_read;
//             end
//             3'b100: begin // lbu
//                 case (byte_offset_reg)
//                     2'b00: MemRead = {24'b0, raw_word_read[7:0]};
//                     2'b01: MemRead = {24'b0, raw_word_read[15:8]};
//                     2'b10: MemRead = {24'b0, raw_word_read[23:16]};
//                     2'b11: MemRead = {24'b0, raw_word_read[31:24]};
//                 endcase
//             end
//             3'b101: begin // lhu
//                 if (byte_offset_reg[1])
//                     MemRead = {16'b0, raw_word_read[31:16]};
//                 else
//                     MemRead = {16'b0, raw_word_read[15:0]};
//             end
//             default: begin
//                 MemRead = 32'b0;
//             end
//         endcase
//     end

// endmodule

module DataMemory (
    input [31:0] address, WriteDataM,
    input [2:0] funct3M,
    input CLK, WE, 
    output reg [31:0] MemRead
);

    // 1024 bytes = 256 words of 32-bits
    (* ram_style = "block" *) reg [31:0] datamem [0:255];

    // Word address is the upper bits. Byte offset is the lower 2 bits.
    wire [7:0] word_addr = address[9:2];
    wire [1:0] byte_offset = address[1:0];

    // ---------------------------------------------------------
    // WRITE LOGIC (Byte-Steering into 32-bit Word)
    // ---------------------------------------------------------
    reg [3:0]  byte_we;
    reg [31:0] aligned_write_data;

    always @(*) begin
        byte_we = 4'b0000;
        aligned_write_data = 32'b0;
        
        if (WE) begin
            case (funct3M)
                3'b000: begin // sb
                    byte_we = 4'b0001 << byte_offset;
                    aligned_write_data = {4{WriteDataM[7:0]}};
                end 
                3'b001: begin // sh
                    byte_we = (byte_offset[1]) ? 4'b1100 : 4'b0011;
                    aligned_write_data = {2{WriteDataM[15:0]}};
                end
                3'b010: begin // sw
                    byte_we = 4'b1111;
                    aligned_write_data = WriteDataM;
                end
                default: begin
                    byte_we = 4'b0000;
                    aligned_write_data = 32'b0;
                end
            endcase
        end
    end

    // Synchronous Write Process Block RAM
    always @(posedge CLK) begin
        if (byte_we[0]) datamem[word_addr][7:0]   <= aligned_write_data[7:0];
        if (byte_we[1]) datamem[word_addr][15:8]  <= aligned_write_data[15:8];
        if (byte_we[2]) datamem[word_addr][23:16] <= aligned_write_data[23:16];
        if (byte_we[3]) datamem[word_addr][31:24] <= aligned_write_data[31:24];
    end

    // ---------------------------------------------------------
    // READ LOGIC (With Write-First Hardware Bypass)
    // ---------------------------------------------------------
    reg [31:0] raw_word_read;
    reg [1:0]  byte_offset_reg;
    reg [2:0]  funct3M_reg;

    always @(posedge CLK) begin
        // If writing and reading the exact same address at the same time,
        // bypass the memory array matrix and pass the incoming write data
        // directly into our output register block (WRITE_FIRST emulation).
        if (WE && (byte_we != 4'b0000)) begin
            raw_word_read[7:0]   <= byte_we[0] ? aligned_write_data[7:0]   : datamem[word_addr][7:0];
            raw_word_read[15:8]  <= byte_we[1] ? aligned_write_data[15:8]  : datamem[word_addr][15:8];
            raw_word_read[23:16] <= byte_we[2] ? aligned_write_data[23:16] : datamem[word_addr][23:16];
            raw_word_read[31:24] <= byte_we[3] ? aligned_write_data[31:24] : datamem[word_addr][31:24];
        end else begin
            raw_word_read   <= datamem[word_addr];
        end
        
        byte_offset_reg <= byte_offset;
        funct3M_reg     <= funct3M;
    end

    // Post-read multiplexing and sign extension
    always @(*) begin
        case (funct3M_reg)
            3'b000: begin // lb
                case (byte_offset_reg)
                    2'b00: MemRead = {{24{raw_word_read[7]}},  raw_word_read[7:0]};
                    2'b01: MemRead = {{24{raw_word_read[15]}}, raw_word_read[15:8]};
                    2'b10: MemRead = {{24{raw_word_read[23]}}, raw_word_read[23:16]};
                    2'b11: MemRead = {{24{raw_word_read[31]}}, raw_word_read[31:24]};
                endcase
            end
            3'b001: begin // lh
                if (byte_offset_reg[1])
                    MemRead = {{16{raw_word_read[31]}}, raw_word_read[31:16]};
                else
                    MemRead = {{16{raw_word_read[15]}}, raw_word_read[15:0]};
            end
            3'b010: begin // lw
                MemRead = raw_word_read;
            end
            3'b100: begin // lbu
                case (byte_offset_reg)
                    2'b00: MemRead = {24'b0, raw_word_read[7:0]};
                    2'b01: MemRead = {24'b0, raw_word_read[15:8]};
                    2'b10: MemRead = {24'b0, raw_word_read[23:16]};
                    2'b11: MemRead = {24'b0, raw_word_read[31:24]};
                endcase
            end
            3'b101: begin // lhu
                if (byte_offset_reg[1])
                    MemRead = {16'b0, raw_word_read[31:16]};
                else
                    MemRead = {16'b0, raw_word_read[15:0]};
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