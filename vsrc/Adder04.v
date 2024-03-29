`timescale 1ns / 1ps

module Adder04 (  //四位超前进位快速加法器
    input        cin,
    input  [3:0] in1,
    input  [3:0] in2,
    output [3:0] out,
    output       cout
);
  wire [3:0] G = in1 & in2;  //进位生成
  wire [3:0] P = in1 ^ in2;  //进位传播
  wire [3:0] C;  //进位

  assign C[0] = cin;
  assign C[1] = G[0] | (P[0] & cin);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
  assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);

  assign out = P ^ C[3:0];

endmodule
