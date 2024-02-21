`timescale 1ns / 1ps

module CLAdder #(  //Carry-Lookahead Adder
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
