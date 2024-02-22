`timescale 1ns / 1ps

module CSA3T2 #(  //Carry Save Adder 3-2
    WIDTH = 32
) (
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    input  [WIDTH-1:0] in3,
    output [WIDTH-1:0] out,
    output [WIDTH-1:0] cout
);
  wire [WIDTH-1:0] wcout;
  generate
    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin : gen
      FullAdder FullAdder_inst (
          .in1 (in1[i]),
          .in2 (in2[i]),
          .in3 (in3[i]),
          .out (out[i]),
          .cout(wcout[i])
      );
    end
  endgenerate
  assign cout = wcout << 1;
endmodule
