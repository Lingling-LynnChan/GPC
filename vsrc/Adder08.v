`timescale 1ns / 1ps

module Adder08 (  //八位超前进位快速加法器
    input        cin,
    input  [7:0] in1,
    input  [7:0] in2,
    output [7:0] out,
    output       cout
);
  wire carry;
  Adder04 Adder04_inst0 (
      .cin (cin),
      .in1 (in1[3:0]),
      .in2 (in2[3:0]),
      .out (out[3:0]),
      .cout(carry)
  );
  Adder04 Adder04_inst1 (
      .cin (carry),
      .in1 (in1[7:4]),
      .in2 (in2[7:4]),
      .out (out[7:4]),
      .cout(cout)
  );
endmodule
