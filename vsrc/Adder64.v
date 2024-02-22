`timescale 1ns / 1ps

module Adder64 (  //六十四位超前进位快速加法器
    input         cin,
    input  [63:0] in1,
    input  [63:0] in2,
    output [63:0] out,
    output        cout
);
  wire carry;
  Adder32 Adder32_inst0 (
      .cin (cin),
      .in1 (in1[31:0]),
      .in2 (in2[31:0]),
      .out (out[31:0]),
      .cout(carry)
  );
  Adder32 Adder32_inst1 (
      .cin (carry),
      .in1 (in1[63:32]),
      .in2 (in2[63:32]),
      .out (out[63:32]),
      .cout(cout)
  );
endmodule
