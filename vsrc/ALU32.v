`timescale 1ns / 1ps

module ALU32 #(
    WIDTH  = 32,
    NR_SEL = 8    //指令分支数
) (
    input  [      9:0] fun,    //{funct3, funct7: 默认0}
    input  [      5:0] itype,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
);
  wire [WIDTH-1:0] outs    [NR_SEL:0];
  wire [WIDTH-1:0] in2_sxx;
  wire             in1_sel;
  //连线
  assign in2_sxx = {{(WIDTH - 5) {1'b0}}, in2[4:0]};
  assign in1_sel = (itype[4] & (in2[11:5] == 7'h20)) | (itype[5] & fun[6]);
  assign outs[1] = in1 ^ in2;
  assign outs[2] = in1 | in2;
  assign outs[3] = in1 & in2;
  assign outs[4] = in1 << in2;
  assign outs[5] = in1_sel ? $signed(in1) >>> in2_sxx : in1 >> in2_sxx;
  assign outs[6] = $signed(in1) < $signed(in2) ? 1 : 0;
  assign outs[7] = in1 < in2 ? 1 : 0;
  Mux #(
      .NR(NR_SEL),
      .KW(9),
      .DW(WIDTH)
  ) Mux_inst (
      .out(out),
      .sel({fun[9:7], fun[5:0]}  /*{funct3, funct7[5:0]}*/),
      .def(0),
      .lut({  //输出映射列表
        {3'h0, 6'h0, outs[0]},  //add/sub
        {3'h4, 6'h0, outs[1]},  //xor
        {3'h6, 6'h0, outs[2]},  //or
        {3'h7, 6'h0, outs[3]},  //and
        {3'h1, 6'h0, outs[4]},  //sll
        {3'h5, 6'h0, outs[5]},  //srl/sra
        {3'h2, 6'h0, outs[6]},  //slt
        {3'h3, 6'h0, outs[7]}  //sltu
      })
  );
  Adder #(
      .WIDTH(WIDTH)
  ) Adder_inst (
      .cin (0),
      .in1 (in1),
      .in2 (~fun[6] ? in2 : (~in2 + 1)),
      .out (outs[0]),
      .cout()
  );
endmodule
