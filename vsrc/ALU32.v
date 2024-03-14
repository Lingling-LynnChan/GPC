`timescale 1ns / 1ps

module ALU32 #(
    WIDTH   = 32,
    NR_INST = 46
) (
    input  [OPC_WIDTH-1:0] opc,
    input  [    WIDTH-1:0] in1,
    input  [    WIDTH-1:0] in2,
    output [    WIDTH-1:0] out
);
  parameter OPC_WIDTH = $clog2(NR_INST + 1);
endmodule
