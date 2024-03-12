`timescale 1ns / 1ps

module ALU32 (
    input         opc,    //独热码
    input         valid,  //是否由算数逻辑单元处理
    input  [31:0] in1,
    input  [31:0] in2,
    output [31:0] out
);
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

endmodule
