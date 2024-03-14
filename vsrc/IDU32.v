`timescale 1ns / 1ps

module IDU32 #(  //Instruction Decode Unit
    INST_MAX   = 32,
    WIDTH      = 32,
    ADDR_WIDTH = 32
) (
    input  [INST_MAX-1:0] inst,
    output                d0en,
    output                s1en,
    output                s2en,
    output [   WIDTH-1:0] d0,        //目的地址或B指令中的imm
    output [   WIDTH-1:0] s1,        //源1寄存器地址
    output [   WIDTH-1:0] s2,        //源2寄存器地址或imm
    output [         9:0] fun,
    output [         5:0] inst_type  //独热码 R I S B U J
);
  // parameter R_TYPE_ALU = 7'b011_0011;  //R指令算术逻辑组
  // parameter I_TYPE_ALU = 7'b001_0011;  //I指令算术逻辑组
  // parameter I_TYPE_LOD = 7'b000_0011;  //I指令内存读取组
  // parameter S_TYPE_STO = 7'b010_0011;  //S指令内存写回组
  // parameter B_TYPE_JMP = 7'b110_0011;  //B指令比较跳转组
  // parameter J_TYPE_JMP = 7'b110_1111;  //J指令立即跳转组
  // parameter I_TYPE_JMP = 7'b110_0111;  //J指令立即跳转组
  // parameter U_TYPE_LUI = 7'b011_0111;  //U指令LUI组
  // parameter U_TYPE_AUI = 7'b001_0111;  //U指令AUIPC组
  // parameter I_TYPE_ENV = 7'b111_0011;  //I指令环境调用组

  wire [ 6:0] opcode = inst[6:0];
  wire [ 2:0] funct3 = inst[14:12];
  wire [ 6:0] funct7 = inst[31:25];
  wire [ 4:0] rd = inst[11:7];
  wire [ 4:0] rs1 = inst[19:15];
  wire [ 4:0] rs2 = inst[24:20];
  wire [31:0] imm_i;
  wire [31:0] imm_s;
  wire [31:0] imm_b;
  wire [31:0] imm_u;
  wire [31:0] imm_j;
  //TODO: 添加指令分类操作
  //SLLi、SRLi、SRAi指令需要

  //模块连线
  assign fun = {funct3, funct7};
  IDU32_Decoder IDU32_Decoder_inst (
      .inst (inst),
      .imm_i(imm_i),
      .imm_s(imm_s),
      .imm_b(imm_b),
      .imm_u(imm_u),
      .imm_j(imm_j)
  );
endmodule
