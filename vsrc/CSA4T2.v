`timescale 1ns / 1ps

module CSA4T2 #(  //Carry Save Adder 4-2
    WIDTH = 32
) (
    input              cin,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    input  [WIDTH-1:0] in3,
    input  [WIDTH-1:0] in4,
    output [WIDTH-1:0] out,
    output [WIDTH-1:0] cout,
    output             carry
);
  generate
    genvar i;
    wire [WIDTH-1:0] level_s;
    wire [  WIDTH:0] level_c;
    assign level_c[0] = cin;
    assign carry = level_c[WIDTH];
    for (i = 0; i < WIDTH; i = i + 1) begin : gen
      FullAdder FullAdder_LEVEL_1 (
          .in1 (in1[i]),
          .in2 (in2[i]),
          .in3 (in3[i]),
          .out (level_s[i]),   //s
          .cout(level_c[i+1])  //c
      );
      FullAdder FullAdder_LEVEL_2 (
          .in1 (level_s[i]),
          .in2 (in4[i]),
          .in3 (level_c[i]),
          .out (out[i]),
          .cout(cout[i])
      );
    end
  endgenerate
endmodule
