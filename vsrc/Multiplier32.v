`timescale 1ns / 1ps

module Multiplier32 (  //三十二位快速乘法器
    input  [31:0] in1,  //被乘数
    input  [31:0] in2,  //乘数
    output [63:0] out   //积
);

endmodule

module Booth (
    input [31:0] x,
    input [31:0] y0,
    input [31:0] y1,
    input [31:0] y2,
    output P,
    output C
);

endmodule

module Wallace_8In_6Carry_1Bit (  //八输入六进位的一位华莱士树
    input  [5:0] cins,
    input  [7:0] ins,
    output       sout,
    output       cout,
    output [5:0] couts
);
  //第一层
  wire w1[2:0];
  FullAdder inst_1_1 (
      .in1 (ins[0]),
      .in2 (ins[1]),
      .in3 (ins[2]),
      .out (w1[0]),
      .cout(couts[0])
  );
  FullAdder inst_1_2 (
      .in1 (ins[3]),
      .in2 (ins[4]),
      .in3 (ins[5]),
      .out (w1[1]),
      .cout(couts[1])
  );
  HalfAdder inst_1_3 (
      .in1 (ins[6]),
      .in2 (ins[7]),
      .out (w1[2]),
      .cout(couts[2])
  );
  //第二层
  wire w2[1:0];
  FullAdder inst_2_1 (
      .in1 (w1[0]),
      .in2 (w1[1]),
      .in3 (w1[2]),
      .out (w2[0]),
      .cout(couts[3])
  );
  FullAdder inst_2_2 (
      .in1 (cins[0]),
      .in2 (cins[1]),
      .in3 (cins[2]),
      .out (w2[1]),
      .cout(couts[4])
  );
  //第三层
  wire w3;
  FullAdder inst_3_1 (
      .in1 (w2[0]),
      .in2 (w2[1]),
      .in3 (cins[3]),
      .out (w3),
      .cout(couts[5])
  );
  //第四层
  FullAdder inst_4_1 (
      .in1 (w3),
      .in2 (cins[4]),
      .in3 (cins[5]),
      .out (sout),
      .cout(cout)
  );
endmodule
