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
and               2 与
or                3 或
xor               4 异或
sll               5 左移
srl               6 右移（逻辑）
sra               7 右移（算数）
slt               8 小于（有符号）
sltu              9 小于（无符号）
*/
  MuxMap #(
      .NR_KEY  (10),  //键数量
      .KEY_LEN (12),  //键位宽{funct3,funct7}
      .DATA_LEN(10)   //值位宽
  ) MuxMap_inst (
      .out(out),
      .sel(key),
      .default_out({OUT_WIDTH{0}}),
      .lut(lut)
  );
endmodule
