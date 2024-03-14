`timescale 1ns / 1ps

module IDU32 #(  //Instruction Decode Unit
    INST_MAX   = 32,
    WIDTH      = 32
) (
    input  [INST_MAX-1:0] inst,
    output                d0en,   //是目的寄存器（否则是S/B的imm）
    output                s1en,   //是源1寄存器（否则无效）
    output                s2en,   //是源2寄存器（否则是其他的imm）
    output [   WIDTH-1:0] d0imm,  //目的地址或S/B指令中的imm
    output [   WIDTH-1:0] s1,     //源1寄存器地址
    output [   WIDTH-1:0] s2imm,  //源2寄存器地址或imm
    output [         9:0] fun,
    output [         5:0] itype   //独热码 R I S B U J
);
  //指令类型的独热码
  parameter R_TYPE = 5;
  parameter I_TYPE = 4;
  parameter S_TYPE = 3;
  parameter B_TYPE = 2;
  parameter U_TYPE = 1;
  parameter J_TYPE = 0;
  //指令的类型分类
  parameter R_TYPE_ALU = 7'b011_0011;  //R指令算术逻辑组
  parameter I_TYPE_ALU = 7'b001_0011;  //I指令算术逻辑组
  parameter I_TYPE_LOD = 7'b000_0011;  //I指令内存读取组
  parameter I_TYPE_JMP = 7'b110_0111;  //J指令立即跳转组
  parameter I_TYPE_ENV = 7'b111_0011;  //I指令环境调用组
  parameter S_TYPE_STO = 7'b010_0011;  //S指令内存写回组
  parameter B_TYPE_JMP = 7'b110_0011;  //B指令比较跳转组
  parameter U_TYPE_LUI = 7'b011_0111;  //U指令LUI组
  parameter U_TYPE_AUI = 7'b001_0111;  //U指令AUIPC组
  parameter J_TYPE_JMP = 7'b110_1111;  //J指令立即跳转组
  //信号解析
  wire [6:0] opcode = inst[6:0];
  wire [2:0] funct3 = inst[14:12];
  wire [6:0] funct7 = itype[5] ? inst[31:25] : 7'b0;
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
  IDU32_Decoder IDU32_Decoder_inst (
      .inst (inst),
      .imm_i(imm_i),
      .imm_s(imm_s),
      .imm_b(imm_b),
      .imm_u(imm_u),
      .imm_j(imm_j)
  );
endmodule
