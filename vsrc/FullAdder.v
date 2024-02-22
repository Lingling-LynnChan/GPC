`timescale 1ns / 1ps

module FullAdder (  //一位全加器
    input  in1,
    input  in2,
    input  in3,
    output out,
    output cout
);
  wire w1to2;
  wire [1:0] carry;
  HalfAdder HalfAdder_inst1 (
      .in1 (in1),
      .in2 (in2),
      .out (w1to2),
      .cout(carry[0])
  );
  HalfAdder HalfAdder_inst2 (
      .in1 (w1to2),
      .in2 (in3),
      .out (out),
      .cout(carry[1])
  );
  assign cout = carry[0] | carry[1];
endmodule
