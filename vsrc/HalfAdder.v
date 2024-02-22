`timescale 1ns / 1ps

module HalfAdder (  //一位半加器
    input  in1,
    input  in2,
    output out,
    output cout
);
  assign out  = in1 ^ in2;
  assign cout = in1 & in2;
endmodule
