`timescale 1ns / 1ps

module MuxOneHot #(  // 1 << i
    NR = 2,  //数据信号数量
    KW = 1,  //选择信号位宽
    DW = 1   //数据信号位宽
) (
    output [  DW-1:0] out,
    input  [   KW-1:0] sel,
    input  [NR*KW-1:0] inputs
);
  localparam KDW = KW + DW;
  wire [NR*KDW-1:0] lut;
  generate
    genvar i;
    for (i = 0; i < NR; i++) begin
      assign lut[KDW*i+KW-1:KDW*i] = inputs[KW*i+KW-1:KW*i];
      assign lut[KDW*i+KDW-1:KDW*i+KW] = 1 << i;
    end
  endgenerate
  Mux #(
      .NR(NR),
      .KW(KW),
      .DW(DW)
  ) Mux_inst (
      .out(out),
      .sel(sel),
      .def(0),
      .lut(lut)
  );
endmodule