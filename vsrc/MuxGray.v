`timescale 1ns / 1ps

module MuxGray #(
    NR_KEY     = 2,
    KEY_WIDTH  = 1,
    DATA_WIDTH = 1
) (
    output [      DATA_WIDTH-1:0] out,
    input  [       KEY_WIDTH-1:0] sel,
    input  [NR_KEY*KEY_WIDTH-1:0] inputs
);
  wire [NR_KEY*(KEY_WIDTH + DATA_WIDTH)-1:0] lut;
  generate
    genvar i;
    for (i = 0; i < NR_KEY; i++) begin
      assign lut[(KEY_WIDTH+DATA_WIDTH)*i+:KEY_WIDTH] = inputs[KEY_WIDTH*i+:KEY_WIDTH];
      assign lut[((KEY_WIDTH+DATA_WIDTH)*i+KEY_WIDTH)+:DATA_WIDTH] = i ^ (i >> 1);
    end
  endgenerate
  Mux #(
      .NR_KEY    (NR_KEY),
      .KEY_WIDTH (KEY_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) Mux_inst (
      .out(out),
      .sel(sel),
      .def(0),
      .lut(lut)
  );
endmodule
