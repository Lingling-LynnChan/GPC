`timescale 1ns / 1ps

module PC32 #(  //Program Counter
    START_ADDR = 32'h80000000,
    WIDTH = 32
) (
    input              clk,
    input              rst,
    input  [WIDTH-1:0] ipc,
    input  [WIDTH-1:0] imm,
    output [WIDTH-1:0] pc
);
  wire [WIDTH-1:0] wpc;
  Adder #(
      .WIDTH(WIDTH)
  ) Adder_inst (
      .cin (0),
      .in1 (ipc),
      .in2 (imm),
      .out (wpc),
      .cout()
  );
  Reg #(
      .WIDTH    (WIDTH),
      .RESET_VAL(START_ADDR)
  ) Reg_inst (
      .clk (clk),
      .rst (rst),
      .din (wpc),
      .wen (1),
      .dout(pc)
  );

endmodule
