`timescale 1ns / 1ps

module IDU32 #(  //Instruction Decode Unit
    NR_INST = 46
) (
    input  [          6:0] opcode,
    input  [          3:0] funct3,
    input  [          7:0] funct7,
    output [OPC_WIDTH-1:0] opc
);
  parameter OPC_WIDTH = $clog2(NR_INST + 1);
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
      .NR(NR_INST),
      .KW(19),
      .DW(OPC_WIDTH)
  ) Mux_inst (
      .out(opc),
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
        {I_TYPE_ALU, 4'h3, 8'hxx},  //sltui
        {I_TYPE_LOD, 4'h0, 8'hxx},  //lb
        {I_TYPE_LOD, 4'h1, 8'hxx},  //lh
        {I_TYPE_LOD, 4'h2, 8'hxx},  //lw
        {I_TYPE_LOD, 4'h4, 8'hxx},  //lbu
        {I_TYPE_LOD, 4'h5, 8'hxx},  //lhu
        {S_TYPE_STO, 4'h0, 8'hxx},  //sb
        {S_TYPE_STO, 4'h1, 8'hxx},  //sh
        {S_TYPE_STO, 4'h2, 8'hxx},  //sw
        {B_TYPE_JMP, 4'h0, 8'hxx},  //beq
        {B_TYPE_JMP, 4'h1, 8'hxx},  //bne
        {B_TYPE_JMP, 4'h4, 8'hxx},  //blt
        {B_TYPE_JMP, 4'h5, 8'hxx},  //bge
        {B_TYPE_JMP, 4'h6, 8'hxx},  //bltu
        {B_TYPE_JMP, 4'h7, 8'hxx},  //bgeu
        {J_TYPE_JMP, 4'hx, 8'hxx},  //jal
        {I_TYPE_JMP, 4'h0, 8'hxx},  //jalr
        {U_TYPE_LUI, 4'hx, 8'hxx},  //lui
        {U_TYPE_AUI, 4'hx, 8'hxx},  //auipc
        {I_TYPE_ENV, 4'h0, 8'hxx},  //ecall/ebreak imm识别
        {R_TYPE_ALU, 4'h0, 8'h01},  //mul
        {R_TYPE_ALU, 4'h1, 8'h01},  //mulh
        {R_TYPE_ALU, 4'h2, 8'h01},  //mulsu
        {R_TYPE_ALU, 4'h3, 8'h01},  //mulu
        {R_TYPE_ALU, 4'h4, 8'h01},  //div
        {R_TYPE_ALU, 4'h5, 8'h01},  //divu
        {R_TYPE_ALU, 4'h6, 8'h01},  //rem
        {R_TYPE_ALU, 4'h7, 8'h01}  //remu
      })
  );
endmodule
