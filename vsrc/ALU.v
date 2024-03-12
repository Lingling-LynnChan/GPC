`timescale 1ns / 1ps

module ALU #(
    WIDTH  = 32,
    NR_ALU = 10
) (
    input  [NR_ALU-1:0] alu_op,  //独热码
    input  [ WIDTH-1:0] in1,
    input  [ WIDTH-1:0] in2,
    output [ WIDTH-1:0] out,
    output              valid        //是否属于算数单元处理
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
