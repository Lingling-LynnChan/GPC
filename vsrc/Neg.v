module Neg #(
    WIDTH = 32
) (
    input  [WIDTH-1:0] in,
    input              en,
    output [WIDTH-1:0] out
);
  assign out = en ? ~in + 1'b1 : in;
endmodule
