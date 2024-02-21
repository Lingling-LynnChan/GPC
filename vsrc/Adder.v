`timescale 1ns / 1ps

module Adder #(
    WIDTH = 32,
    OUT_WIDTH = 32
) (
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [OUT_WIDTH-1:0] out
);
  assign out = in1 + in2;  //综合出来的加法器肯定比我实现的好

endmodule
