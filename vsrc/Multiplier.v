`timescale 1ns / 1ps

module Multiplier #(  //快速乘法器
    WIDTH = 32
) (
    input  [  WIDTH-1:0] in1,  //被乘数
    input  [  WIDTH-1:0] in2,  //乘数
    output [2*WIDTH-1:0] out   //积
);
  assign out = 0;
  generate
    genvar i, j;
    //所有输入/输出端口
    wire [WIDTH-1:0] ins[2*WIDTH-1:0];
    //原始输入构造: 列竖式，先用乘数的每一位去乘被乘数，得到竖式的每一层
    //事实上，竖式中间结果是一个菱形，中间厚两边薄
    for (i = 0; i < WIDTH; i = i + 1) begin
      assign ins[i] = in1 & {WIDTH{in2[i]}};
    end
    //层数: 第一层有`WIDTH/2`个加法器，每层少一半，最少1个
    localparam V_NUM = $clog2(WIDTH);  //这个函数可以计算最大计算次数
    initial $error("WIDTH: %d", WIDTH);
    for (j = 0; j < V_NUM; j = j + 1) begin : Vertical
      localparam H_NUM = WIDTH >> (j + 1);  //加法器数量
      //每层个数: 当前层有n个加法器，输入端口需要依次连接上一层的输出
      //转化为循环，由于外层数量为2倍，则内层只需要遍历一半`[0,n/2)`即可
      for (i = 0; i < H_NUM; i = i + 1) begin : Horizontal
        //j行i列
        Adder #(
            .WIDTH(WIDTH)
        ) adder (
            .cin (1'b0),
            .in1 (),
            .in2 (),
            .out (),
            .cout()
        );
      end
    end
  endgenerate

endmodule
