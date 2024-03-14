`timescale 1ns / 1ps
`include "_inst_type.vh"
module IDU32Decoder (  //译码单元解码器
    input  [31:0] inst,
    output [ 6:0] opcode,
    output [ 2:0] funct3,
    output [ 6:0] funct7,
    output [31:0] imm_i,
    output [31:0] imm_s,
    output [31:0] imm_b,
    output [31:0] imm_u,
    output [31:0] imm_j
);
  assign opcode = inst[6:0];
  assign funct3 = inst[14:12];
  assign funct7 = opcode == R_TYPE_ALU ? inst[31:25] : 7'b0;
  assign imm_i  = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
  assign imm_s  = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
  assign imm_b  = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
  assign imm_u  = {inst[31], inst[30:20], inst[19:12], 12'b0};
  assign imm_j  = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
endmodule
