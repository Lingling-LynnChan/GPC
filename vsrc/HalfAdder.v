module HalfAdder (
    input  in1,
    input  in2,
    output out,
    output cout
);
  assign out  = in1 ^ in2;
  assign cout = in1 & in2;
endmodule
