`timescale 1ns / 1ps

module ALDU32 (  //Arithmetic Logic Decode Unit: 把指令译为算数逻辑操作码
    input [3:0] funct3,
    input [7:0] funct7,
    input funct7_en,  //imm指令的funct7是无效的
    output [10:0] out,
    output valid
);
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
endmodule
