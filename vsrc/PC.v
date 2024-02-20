`timescale 1ns / 1ps

module PC #(  //Program Counter
    START_ADDR = 32'h80000000,
    WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire set_pc,
    input wire [WIDTH-1:0] new_pc,
    output wire [WIDTH-1:0] pc
);
  wire [WIDTH-1:0] wpc = set_pc ? new_pc : pc + 4;
  Reg #(
      .WIDTH(WIDTH),
      .RESET_VAL(START_ADDR)
  ) reg_pc (
      .clk (clk),
      .rst (rst),
      .din (wpc),
      .wen (1),
      .dout(pc)
  );
endmodule
