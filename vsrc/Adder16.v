`timescale 1ns / 1ps

module Adder16 (  //十六位超前进位快速加法器
    input         cin,
    input  [15:0] in1,
    input  [15:0] in2,
    output [15:0] out,
    output        cout
);
  wire carry;
  Adder08 Adder08_inst0 (
      .cin (cin),
      .in1 (in1[7:0]),
      .in2 (in2[7:0]),
      .out (out[7:0]),
      .cout(carry)
  );
  Adder08 Adder08_inst1 (
      .cin (carry),
      .in1 (in1[15:8]),
      .in2 (in2[15:8]),
      .out (out[15:8]),
      .cout(cout)
  );

endmodule
