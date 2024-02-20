`timescale 1ns / 1ps

module Reg #(
    WIDTH = 1,
    RESET_VAL = 0  //重置值
) (
    input clk,
    input rst,
    input [WIDTH-1:0] din,
    input wen,  //写使能
    output reg [WIDTH-1:0] dout
);
  always @(posedge clk) begin
    if (rst) dout <= RESET_VAL;
    else if (wen) dout <= din;
  end
endmodule
