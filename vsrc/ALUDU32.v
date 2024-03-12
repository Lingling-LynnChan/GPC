`timescale 1ns / 1ps

module ALDU32 (  //Arithmetic Logic Decode Unit: 把指令译为算数逻辑操作码
    input  [          3:0] funct3,
    input  [          7:0] funct7,
    input                  funct7_en,  //imm指令的funct7是无效的
    output [OUT_WIDTH-1:0] out,
    output                 valid
);
  parameter OUT_WIDTH = 10;
  /*
alu_code
add               0 加
sub               1 减
xor               2 异或
or                3 或
and               4 与
sll               5 左移
srl               6 右移（逻辑）
sra               7 右移（算数）
slt               8 小于（有符号）
sltu              9 小于（无符号）
*/
  wire use_funct7_en = funct7_en ? 1 : (  //立即数模式却需要使用funct7的特殊情况
  funct3 == 4'h1 &&  //slli指令
  funct3 == 4'h5  //srli和srai指令
  ) ? 1 : 0;
  Mux_OneHot #(
      .NR_KEY    (10),
      .KEY_WIDTH (12),
      .DATA_WIDTH(10)
  ) Mux_OneHot_inst (
      .out(out),
      .sel({funct3, use_funct7_en ? funct7 : 8'b0}),
      .inputs({  //独热码列表
        {4'h0, 8'h00},  //add
        {4'h0, 8'h20},  //sub
        {4'h4, 8'h00},  //xor
        {4'h6, 8'h00},  //or
        {4'h7, 8'h00},  //and
        {4'h1, 8'h00},  //sll
        {4'h5, 8'h00},  //srl
        {4'h5, 8'h20},  //sra
        {4'h2, 8'h00},  //slt
        {4'h3, 8'h00}  //sltu
      })
  );
  assign valid = (out == 0) ? 1'b1 : 1'b0;
endmodule
