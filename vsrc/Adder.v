`timescale 1ns / 1ps

module Adder #(  //Carry-Lookahead Adder
    WIDTH = 32
) (
    input              cin,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    output [WIDTH-1:0] out,
    output             cout
);
  generate
    if (WIDTH == 4) begin
      Adder04 adder_inst (
          .cin(cin),
          .in1(in1),
          .in2(in2),
          .out({cout, out})
      );
    end else if (WIDTH == 8) begin
      Adder08 adder_inst (
          .cin(cin),
          .in1(in1),
          .in2(in2),
          .out({cout, out})
      );
    end else if (WIDTH == 16) begin
      Adder16 adder_inst (
          .cin(cin),
          .in1(in1),
          .in2(in2),
          .out({cout, out})
      );
    end else if (WIDTH == 32) begin
      Adder32 adder_inst (
          .cin(cin),
          .in1(in1),
          .in2(in2),
          .out({cout, out})
      );
    end else begin
      initial begin
        $error("Unsupported WIDTH: %d. WIDTH must be 4, 8, 16, or 32.", WIDTH);
      end
    end
  endgenerate

endmodule

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

module Adder16 (  //十六位超前进位快速加法器
    input         cin,
    input  [15:0] in1,
    input  [15:0] in2,
    output [16:0] out
);
  wire carry;
  Adder08 Adder08_inst0 (
      .cin(cin),
      .in1(in1[7:0]),
      .in2(in2[7:0]),
      .out({carry, out[7:0]})
  );
  Adder08 Adder08_inst1 (
      .cin(carry),
      .in1(in1[15:8]),
      .in2(in2[15:8]),
      .out(out[16:8])
  );

endmodule

module Adder08 (  //八位超前进位快速加法器
    input        cin,
    input  [7:0] in1,
    input  [7:0] in2,
    output [8:0] out
);
  wire carry;
  Adder04 Adder04_inst0 (
      .cin(cin),
      .in1(in1[3:0]),
      .in2(in2[3:0]),
      .out({carry, out[3:0]})
  );
  Adder04 Adder04_inst1 (
      .cin(carry),
      .in1(in1[7:4]),
      .in2(in2[7:4]),
      .out(out[8:4])
  );
endmodule

module Adder04 (  //四位超前进位快速加法器
    input        cin,
    input  [3:0] in1,
    input  [3:0] in2,
    output [4:0] out
);
  wire [3:0] G = in1 & in2;  //进位生成
  wire [3:0] P = in1 ^ in2;  //进位传播
  wire [4:0] C;  //进位

  assign C[0] = cin;
  assign C[1] = G[0] | (P[0] & cin);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[1] & P[0] & cin);
  assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);

  assign out = {C[4], P ^ C[3:0]};

endmodule
