`timescale 1ns / 1ps

module IDU32 (
    input  [          6:0] opcode,
    input  [          3:0] funct3,
    input  [          7:0] funct7,
    output [OUT_WIDTH-1:0] out
);
  parameter NR_KEY = 19;
  parameter OUT_WIDTH = $clog2(NR_KEY);
  /*
alu_code
//R指令
add               加
sub               减
xor               异或
or                或
and               与
sll               左移
srl               右移（逻辑）
sra               右移（算数）
slt               小于（有符号）
sltu              小于（无符号）
//I指令ALU组
addi              加
subi              减
xori              异或
ori               或
andi              与
slli              左移
srli              右移（逻辑）
srai              右移（算数）
slti              小于（有符号）
slti              小于（无符号）
//I指令LOD组
lb                加载字节（有符号）
lh                加载半字（有符号）
lw                加载字（有符号）
lbu               加载字节（无符号）
lhu               加载半字（无符号）
//S指令
sb                保存到字节
sh                保存到半字
sw                保存到字
//B指令
beq               等于跳转
bne               不等于跳转
blt               小于跳转（有符号）
bge               不小于跳转（有符号）
bltu              小于跳转（无符号）
bgeu              不小于跳转（无符号）
//J指令JMP组
jal               PC偏移跳转
//I指令JMP组
jalr              寄存器偏移跳转
//U指令
lui               大立即数写入寄存器
auipc             大立即数加PC写入寄存器
//I指令环境调用组
ecall             OS调用（类似x86的int指令）
ebreak            DEBUG调用
*/
  parameter R_TYPE_ALU = 7'b0110011;  //R指令算术逻辑组
  parameter I_TYPE_ALU = 7'b0010011;  //I指令算术逻辑组
  parameter I_TYPE_LOD = 7'b0000011;  //I指令内存读取组
  parameter S_TYPE_STO = 7'b0100011;  //S指令内存写回组
  parameter B_TYPE_JMP = 7'b1100011;  //B指令比较跳转组
  parameter J_TYPE_JMP = 7'b1101111;  //J指令立即跳转组
  parameter I_TYPE_JMP = 7'b1100111;  //J指令立即跳转组
  parameter U_TYPE_LUI = 7'b0110111;  //U指令LUI组
  parameter U_TYPE_AUI = 7'b0010111;  //U指令AUIPC组
  parameter I_TYPE_ENV = 7'b1110011;  //I指令环境调用组
  MuxIdx #(
      .NR_KEY    (NR_KEY),
      .KEY_WIDTH (19),
      .DATA_WIDTH(OUT_WIDTH)
  ) Mux_inst (
      .out(out),
      .sel({opcode, funct3, funct7}),
      .inputs({  //编码映射列表
        {R_TYPE_ALU, 4'h0, 8'h00},  //add
        {R_TYPE_ALU, 4'h0, 8'h20},  //sub
        {R_TYPE_ALU, 4'h4, 8'h00},  //xor
        {R_TYPE_ALU, 4'h6, 8'h00},  //or
        {R_TYPE_ALU, 4'h7, 8'h00},  //and
        {R_TYPE_ALU, 4'h1, 8'h00},  //sll
        {R_TYPE_ALU, 4'h5, 8'h00},  //srl
        {R_TYPE_ALU, 4'h5, 8'h20},  //sra
        {R_TYPE_ALU, 4'h2, 8'h00},  //slt
        {R_TYPE_ALU, 4'h3, 8'h00},  //sltu
        {I_TYPE_ALU, 4'h0, 8'hxx},  //addi
        {I_TYPE_ALU, 4'h4, 8'hxx},  //xori
        {I_TYPE_ALU, 4'h6, 8'hxx},  //ori
        {I_TYPE_ALU, 4'h7, 8'hxx},  //andi
        {I_TYPE_ALU, 4'h1, 8'h00},  //slli
        {I_TYPE_ALU, 4'h5, 8'h00},  //srli
        {I_TYPE_ALU, 4'h5, 8'h20},  //srai
        {I_TYPE_ALU, 4'h2, 8'hxx},  //slti
        {I_TYPE_ALU, 4'h3, 8'hxx}  //sltui
      })
  );
endmodule
