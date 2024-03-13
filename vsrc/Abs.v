`timescale 1ns / 1ps

module Abs #(  //绝对值
    WIDTH = 32
) (
    input              en,
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out,
    output             neg
);
  assign neg = en & in[WIDTH-1];
  Neg #(
      .WIDTH(WIDTH)
  ) Neg_inst (
      .in (in),
      .en (neg),
      .out(out)
  );
endmodule
