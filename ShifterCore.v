`timescale 1ns/1ps
module MUX_1_bit2to1 (
    input a, b, s,
    output c
);

assign c = s ? a : b;
    
endmodule

module ShifterCore (
    input [31:0]number,
    input [4:0]value,
    input U,
    output [31:0]shifted_val
);

wire [31:0]gen_out1, gen_out2, gen_out3, gen_out4, gen_out5;
wire t1, t2, t3, t4, t5;
genvar i;
generate
    MUX_1_bit2to1 C1(.a(number[31]), .b(1'b0), .s(U), .c(t1));
    for (i = 0; i < 32 ; i = i + 1) begin : Level_1_LOOP
        if (i == 31) begin
            MUX_1_bit2to1 M(.a(t1), .b(number[31]), .s(value[0]), .c(gen_out1[31]));
        end else begin
            MUX_1_bit2to1 M(.a(number[i + 1]), .b(number[i]), .c(gen_out1[i]), .s(value[0])); 
        end
    end

    MUX_1_bit2to1 C2(.a(gen_out1[31]), .b(1'b0), .s(U), .c(t2));
    for (i = 0; i < 32; i = i + 1) begin : Level_2_LOOP
        if (i >= 30) begin
            MUX_1_bit2to1 M2 (.a(t2), .b(gen_out1[i]), .c(gen_out2[i]), .s(value[1]));
        end else begin
            MUX_1_bit2to1 M2 (.a(gen_out1[i + 2]), .b(gen_out1[i]), .c(gen_out2[i]), .s(value[1]));
        end
    end

    MUX_1_bit2to1 C3(.a(gen_out2[31]), .b(1'b0), .s(U), .c(t3));
    for (i = 0; i < 32; i = i + 1) begin : Level_3_LOOP
        if (i >= 28) begin
            MUX_1_bit2to1 M3 (.a(t3), .b(gen_out2[i]), .c(gen_out3[i]), .s(value[2]));
        end else begin
            MUX_1_bit2to1 M3 (.a(gen_out2[i + 4]), .b(gen_out2[i]), .c(gen_out3[i]), .s(value[2]));
        end
    end

    MUX_1_bit2to1 C4(.a(gen_out3[31]), .b(1'b0), .s(U), .c(t4));
    for (i = 0; i < 32; i = i + 1) begin : Level_4_LOOP
        if (i >= 24) begin
            MUX_1_bit2to1 M4 (.a(t4), .b(gen_out3[i]), .c(gen_out4[i]), .s(value[3]));
        end else begin
            MUX_1_bit2to1 M4 (.a(gen_out3[i + 8]), .b(gen_out3[i]), .c(gen_out4[i]), .s(value[3]));
        end
    end

    MUX_1_bit2to1 C5(.a(gen_out4[31]), .b(1'b0), .s(U), .c(t5));
    for (i = 0; i < 32; i = i + 1) begin : Level_5_LOOP
        if (i >= 16) begin
            MUX_1_bit2to1 M5 (.a(t5), .b(gen_out4[i]), .c(gen_out5[i]), .s(value[4]));
        end else begin
            MUX_1_bit2to1 M5 (.a(gen_out4[i + 16]), .b(gen_out4[i]), .c(gen_out5[i]), .s(value[4]));
        end
    end

endgenerate

assign shifted_val = gen_out5;
    
endmodule