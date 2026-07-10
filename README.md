# RV32I 5-Stage Pipelined Processor Core
This is an individual project, that implements an FPGA synthesizable, 32-bit RISC-V RV32I processor core. The processor is split into the classical 5 stages, Instruction Fetch, Decode, Execute, Memory and Writeback stage. In addition it includes a Hazard Unit, responsible for handling both control and data hazards. It follows the Harvard Architecture, wherein the Data Memory and Instruction Memory are Isolated. The maximum speed achieved thus far is around 53MHz. Execution accuracy was determined with the help of Icarus and GTKWave. Timing constraints and resource utilization were analyzed with the help of Vivado.  
## Features
1. Supports RV32I User Level Operations.
2. 5-stage Pipelined.
3. Hazard Detection and Data Forwarding between stages.
## Processor Specifications
Will write this later. 

## Pipelined Architecture
The processor mainly contains the following major subsystems:
- IF
- ID
- EX
- MEM
- WB
- Hazard Unit.

I shall try my best to explain the RTL so written in as concise and detailed manner as possible. It should be kept in mind, however, this project was written at an early stage of learning Verilog/SystemVerilog. Some sections of code are highly optimized, whereas others are written at gate level.

### Instruction Fetch Stage
This stage deals with fetching the instructions provided by user. As mentioned earlier, the processor follows the Harvard Architecture, thus Instruction Memory is separated from Data Memory. The memory has a capacity to store 1024 compiled and assembled instructions. The instructions, in this project, are written in the file "program.mem", in the form of Hexadecimal numbers of size 32bits. If the program written is less than the maximum capacity, the instructions are filled automatically with 0x00000000. 

This entire stage is encapsulated under the module "IF". The module contains the pipeline register, responsible for stalling instruction fetch as well.
The register reads between PC+4 and PCTarget. The 2 data lines are chosen via a MUX. Since the processor has no Branch prediction, whether or not to branch is realised only in the EX stage. If the processor realizes it needs to branch, it immediately chooses PCTarget. Otherwise, PC+4 data line is chosen. The choice then is read into the pipeline register. If it is not stalled, on the next clock cycle, this data is forwarded to the other components of the IF stage. 
```verilog
wire [31:0]tPCPlus4, t0, tPCF, meminput;
assign t0 = PCSrc ? PCTargetE : tPCPlus4;
Bit32PIPORegister Reg_F(.write(t0), .Load_cmd(~stallF), .CLK(CLK), .Flush(MegaResetIF), .read(tPCF)); //was 1'b1
```
Wire t0 carries the choice of the MUX, into the pipeline register, which then, reads that on the next cycle to tPCF. tPCF carries the address at which the requested program exists. 

NOTE:
The instruction memory is word addressed! Thus in program.mem, the first line of instruction is at location 0, then 4 then 8 and so on. Now, it is a good practice as a designer to keep in mind Murphy's law:

**"That which CAN go wrong WILL go WRONG".**

Thus, it was imperative to assume that the location carried by tPCF may not always be Word aligned! Hence the next piece of processing was done:
```verilog
genvar i;
generate
    for (i = 0; i < 30 ; i = i + 1) begin
        assign meminput[i] = tPCF[i + 2];        
    end
    assign meminput[31] = 1'b0;
    assign meminput[30] = 1'b0;
endgenerate
```
In this, the address given is first right shifted by 2 places, instantly making it a multiple of 4. Hence, the instruction memory will always recieve a valid, though not necessarily correct,  address. The job of the processor is not to decide whether the location provided is semantically correct as intended by user or not. It's supposed to simply keep processing the instructions that are provided to it. 

PC + 4 is calculated within this stage and directly sent back to the MUX at the start. The memory unit outputs the 32 bit instruction recieved. and sends it to IF_D pipeline register, to be forwarded to Decode Stage in the subsequent clock cycle. 
3 things are forwarded to Decode Stage not necessarily to be used by it:
- Instruction Fetched
- PC associated with Instruction fetched
- PC+4 a.k.a the PC of next instruction.

![IF Stage](IF_Stage.png)
  
### Decode Stage
The decode stage consists of 3 sub units. This stage is accountable for generating the correct control signals, preparing required data and essentially making sense of the 32-bit instruction provided by the Fetch stage. It also houses the Register File, which is a 32 x 32 grid of Flip Flops. 

The 3 subsystems in this stage are:
- Register File
- Extend Unit
- Control Unit

#### 1.Extend Unit
This unit is responsible for decoding the instruction and inferring the immediate value intended by instruction. It should be noted that every instruction does not necessarily have a immediate value. Yet, the Extend Unit, being largely combinational in nature, always provides an interpretation. It is up to the subsequent stages to decide whether or not to use the interpretted immediate value.

The Extend Unit takes as input 3 control signals:
- ImmControl (3 bit)
- op_5 (2nd Bit of opcode from MSB)
- op_3 (4th bit of opcode from MSB)

Aside from these, it has been noticed that all the instruction types within the RV32I ISA, will, if they do, have their immediate field present within the first 25 bits of the instruction in some form or the other. These 25 bits are then parellely decoded for each instruction type. They are then passed through the MUX layer, with the appropriate control signals. The output is a 32 bit immediate value. 

```verilog
wire [31:0]U, Ilbjalr, S, jal, B, t0, t1;
assign U = {immediate[24:5], 12'b0};
assign Ilbjalr = {{20{immediate[24]}}, immediate[24:13]};
assign S = {{20{immediate[24]}}, immediate[24:18], immediate[4:0]};
assign jal = {{11{immediate[24]}}, immediate[24], immediate[12:5], immediate[13], immediate[23:14], 1'b0};
assign B = {{19{immediate[24]}}, immediate[24], immediate[0], immediate[23:18], immediate[4:1], 1'b0};
```
In the decoding of immediate values for each instruction type, no specific logic has been used. As specified, by the ISA, the immediate has been unscrambled. The logical reasoning is involved in the MUX process. 
```text
The distinct opcodes for each instruction type are as follows:
1. U-Type
    - lui    : 0_(1)_1_(0)_111
    - auipic : 0_(0)_1_(0)_111
2. I-Type
    - all    : 0_(0)_1_(0)_011
    - loads  : 0_(0)_0_(0)_011
3. R-Type
    - all    : 0_(1)_1_(0)_011
4. S-Type
    - all    : 0_(1)_0_(0)_011
5. J-Type
    - jal    : 1_(1)_0_(1)_111
    - jalr   : 1_(1)_0_(0)_111
6. B-Type
    - all    : 1_(1)_0_(0)_011
```
The bits in brackets are the ones being passed into the Extend Unit as control signals. 
