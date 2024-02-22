`timescale 1ns / 1ps

module Multiplier #(  //快速乘法器
    WIDTH = 32
) (
    input  [  WIDTH-1:0] in1,  //被乘数
    input  [  WIDTH-1:0] in2,  //乘数
    output [2*WIDTH-1:0] out   //积
);
  
endmodule
