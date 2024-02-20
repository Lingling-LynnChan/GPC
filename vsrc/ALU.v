`timescale 1ns / 1ps

module ALU #(
    WIDTH = 32
) (
    input [9:0] funct,  //{funct7,funct3}
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
);

endmodule
