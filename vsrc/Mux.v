`timescale 1ns / 1ps

module Mux #(
    NR = 2,  //数据信号数量
    KW = 1,  //选择信号位宽
    DW = 1   //数据信号位宽
) (
    output reg [          DW-1:0] out,
    input      [          KW-1:0] sel,
    input      [          DW-1:0] def,  //默认输出
    input      [NR*(KW + DW)-1:0] lut
);
  localparam KDW = KW + DW;
  wire [KDW-1:0] kv_list[NR-1:0];
  wire [ KW-1:0] k_list [NR-1:0];
  wire [ DW-1:0] v_list [NR-1:0];

  generate
    genvar n;
    for (n = 0; n < NR; n = n + 1) begin
      assign kv_list[n] = lut[KDW*(n+1)-1 : KDW*n];
      assign v_list[n]  = kv_list[n][DW-1:0];
      assign k_list[n]  = kv_list[n][KDW-1:DW];
    end
  endgenerate

  reg [DW-1 : 0] lut_out;
  reg hit;
  integer i;
  always @(*) begin
    lut_out = 0;
    hit = 0;
    for (i = 0; i < NR; i = i + 1) begin
      lut_out = lut_out | ({DW{sel == k_list[i]}} & v_list[i]);
      hit = hit | (sel == k_list[i]);
    end
    out = (hit ? lut_out : def);
  end
endmodule
