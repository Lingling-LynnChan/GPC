`timescale 1ns / 1ps

module MEM #(
    WIDTH = 32
) (
    input clk,
    input rst,
    input wen1,
    input [WIDTH-1:0] addrw1,
    input [WIDTH-1:0] dataw1,
    input wen2,
    input [WIDTH-1:0] addrw2,
    input [WIDTH-1:0] dataw2,
    input rena,
    input [WIDTH-1:0] addra,
    input renb,
    input [WIDTH-1:0] addrb,
    output [WIDTH-1:0] outa,
    output [WIDTH-1:0] outb
);
  //TODO: RAM IO
  assign outa = 0;
  assign outb = 0;
endmodule
