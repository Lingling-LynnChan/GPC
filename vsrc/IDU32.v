`timescale 1ns / 1ps
`include "InstType.vh"
module IDU32 #(  //Instruction Decode Unit
    INST_MAX = 32,
    WIDTH    = 32
) (
    input  [INST_MAX-1:0] inst,
    output                d0en,    //是目的寄存器（否则是S/B的imm）
    output                s1en,    //是源1寄存器（否则无效）
    output                s2en,    //是源2寄存器（否则是其他的imm）
    output [   WIDTH-1:0] d0imm,   //目的地址或S/B指令中的imm
    output [   WIDTH-1:0] s1,      //源1寄存器地址
    output [   WIDTH-1:0] s2imm,   //源2寄存器地址或imm
    output [         9:0] fun,
    output [         6:0] opcode,
    output [         5:0] itype    //独热码 R I S B U J
);
  //信号解析
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire [4:0] rd = inst[11:7];
  wire [4:0] rs1 = inst[19:15];
  wire [4:0] rs2 = inst[24:20];
  wire [31:0] imm_i;
  wire [31:0] imm_s;
  wire [31:0] imm_b;
  wire [31:0] imm_u;
  wire [31:0] imm_j;
  //数据请求方法
  wire ienv = opcode == I_TYPE_ENV;
  assign d0en = ~itype[B_TYPE] & ~ienv;
  assign s1en = ~itype[J_TYPE] & ~ienv;
  assign s2en = itype[R_TYPE] | itype[S_TYPE] | itype[B_TYPE];
  //数据获取
  assign d0imm = d0en ? {27'b0, rd} :  //rd寄存器地址
      itype[S_TYPE] ? imm_s :  //S指令
      itype[B_TYPE] ? imm_b : 0;  //B指令
  assign s1 = s1en ? {27'b0, rs1} : 0;  //rs1寄存器地址
  assign s2imm = s2en ? {27'b0, rs2} :  //rs2寄存器地址
      itype[I_TYPE] ? imm_i :  //I指令
      itype[U_TYPE] ? imm_u :  //U指令
      itype[J_TYPE] ? imm_j : 0;  //J指令
  //模块连线
  assign fun = {funct3, funct7};
  assign itype[R_TYPE] = opcode == R_TYPE_ALU;
  assign itype[I_TYPE] = opcode == I_TYPE_ALU && opcode == I_TYPE_ENV && opcode == I_TYPE_JMP && opcode == I_TYPE_LOD;
  assign itype[S_TYPE] = opcode == S_TYPE_STO;
  assign itype[B_TYPE] = opcode == B_TYPE_JMP;
  assign itype[U_TYPE] = opcode == U_TYPE_AUI && opcode == U_TYPE_LUI;
  assign itype[J_TYPE] = opcode == J_TYPE_JMP;
  IDU32Decoder IDU32Decoder_inst (
      .inst  (inst),
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .imm_i (imm_i),
      .imm_s (imm_s),
      .imm_b (imm_b),
      .imm_u (imm_u),
      .imm_j (imm_j)
  );
endmodule
