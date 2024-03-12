`timescale 1ns / 1ps

module MuxMap #(
    NR_KEY     = 2,
    KEY_WIDTH  = 1,
    DATA_WIDTH = 1
) (
    output reg [                     DATA_WIDTH-1:0] out,
    input      [                      KEY_WIDTH-1:0] sel,
    input      [                     DATA_WIDTH-1:0] def,  //默认输出
    input      [NR_KEY*(KEY_WIDTH + DATA_WIDTH)-1:0] lut
);
  localparam PAIR_LEN = KEY_WIDTH + DATA_WIDTH;
  wire [  PAIR_LEN-1:0] pair_list[NR_KEY-1:0];
  wire [ KEY_WIDTH-1:0] key_list [NR_KEY-1:0];
  wire [DATA_WIDTH-1:0] data_list[NR_KEY-1:0];

  generate
    genvar n;
    for (n = 0; n < NR_KEY; n = n + 1) begin
      assign pair_list[n] = lut[PAIR_LEN*(n+1)-1 : PAIR_LEN*n];
      assign data_list[n] = pair_list[n][DATA_WIDTH-1:0];
      assign key_list[n]  = pair_list[n][PAIR_LEN-1:DATA_WIDTH];
    end
  endgenerate

  reg [DATA_WIDTH-1 : 0] lut_out;
  reg hit;
  integer i;
  always @(*) begin
    lut_out = 0;
    hit = 0;
    for (i = 0; i < NR_KEY; i = i + 1) begin
      lut_out = lut_out | ({DATA_WIDTH{sel == key_list[i]}} & data_list[i]);
      hit = hit | (sel == key_list[i]);
    end
    out = (hit ? lut_out : def);
  end
endmodule
