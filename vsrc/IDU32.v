`timescale 1ns / 1ps

module IDU32 (  //Arithmetic Logic Decode Unit: 把指令译为算数逻辑操作码
    input  [          6:0] opcode,
    input  [          3:0] funct3,
    input  [          7:0] funct7,
    output [OUT_WIDTH-1:0] out
);
  parameter NR_KEY = 10;
  parameter OUT_WIDTH = $clog2(NR_KEY);
  /*
alu_code
//R指令
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
//TODO
beq               10 等于
bne               11 不等于
blt               12 小于（有符号）
bge               13 不小于（有符号）
bltu              14 小于（无符号）
bgeu              15 不小于（无符号）
*/
  parameter R_TYPE = 7'b0110011;
  MuxIdx #(
      .NR_KEY    (NR_KEY),
      .KEY_WIDTH (19),
      .DATA_WIDTH(OUT_WIDTH)
  ) Mux_inst (
      .out(out),
      .sel({opcode, funct3, funct7}),
      .inputs({  //编码映射列表
        {R_TYPE, 4'h0, 8'h00},  //add
        {R_TYPE, 4'h0, 8'h20},  //sub
        {R_TYPE, 4'h4, 8'h00},  //xor
        {R_TYPE, 4'h6, 8'h00},  //or
        {R_TYPE, 4'h7, 8'h00},  //and
        {R_TYPE, 4'h1, 8'h00},  //sll
        {R_TYPE, 4'h5, 8'h00},  //srl
        {R_TYPE, 4'h5, 8'h20},  //sra
        {R_TYPE, 4'h2, 8'h00},  //slt
        {R_TYPE, 4'h3, 8'h00}  //sltu
      })
  );
endmodule
