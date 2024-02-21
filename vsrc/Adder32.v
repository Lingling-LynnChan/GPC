module Adder32 (  //三十二位超前进位快速加法器
    input         cin,
    input  [31:0] in1,
    input  [31:0] in2,
    output [32:0] out
);
  wire carry;
  Adder16 Adder16_inst0 (
      .cin(cin),
      .in1(in1[15:0]),
      .in2(in2[15:0]),
      .out({carry, out[15:0]})
  );
  Adder16 Adder16_inst1 (
      .cin(carry),
      .in1(in1[31:16]),
      .in2(in2[31:16]),
      .out(out[32:16])
  );
endmodule
