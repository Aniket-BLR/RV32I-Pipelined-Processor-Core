`timescale 1ns/1ps
module InstructionMemory (
    input [31:0]A,
    input CLK, reset, 
    output reg [31:0]instruction 
);

reg [31:0] mem [0:1023];
initial begin
    integer i;
    for (i = 0; i < 1024; i = i + 1) begin
        mem[i] = 32'b00000000000000000000000000000000;
    end
end

initial begin
    $readmemh("Simulation/program.mem", mem);
end

always @(posedge CLK) begin
    if (!reset) begin
        instruction <= '0; 
    end else begin
        instruction <= mem[A];
    end 
end

//Hoping to simulate SRAM behavior with this
//assign instruction = mem[A];

endmodule