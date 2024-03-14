`timescale 1ns / 1ps

module ALU32 #(
    WIDTH = 32
) (
    input  [      9:0] fun,        //{funct3, funct7: 默认0}
    input  [      5:0] inst_type,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
);
  wire signed [WIDTH-1:0] in1_signed = in1;
  wire [WIDTH-1:0] outs[17:0];
  Mux #(
      .NR(18),
      .KW(3),
      .DW(WIDTH)
  ) Mux_inst (
      .out(out),
      .sel({fun[9:7], fun[5:0]}  /*{funct3, funct7[5:0]}*/),
      .def(0),
      .lut({  //输出映射列表
        {3'h0, 6'h0, outs[0]},  //add/sub
        {3'h4, 6'h0, outs[1]},  //xor
        {3'h6, 6'h0, out[2]},  //or
        {3'h7, 6'h0, out[3]},  //and
        {3'h1, 6'h0, out[4]},  //sll
        {3'h5, 6'h0, out[5]},  //srl/sra
        {3'h2, 6'h0, out[5]},  //slt
        {3'h3, 6'h0, out[5]}  //sltu
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
  assign outs[2] = in1 ^ in2;
  assign outs[3] = in1 | in2;
  assign outs[4] = in1 & in2;
  assign outs[5] = in1 << in2;
  assign outs[6] = inst_type[4] ?  //指令类型检验
      (in2[11] ?  //方法检验
      in1_signed >>> in2[4:0] :  //I指令算术右移
      in1 >> in2[4:0]) :  //I指令逻辑右移
      (fun[6] ?  //方法检验
      in1_signed >>> in2 :  //R指令算术右移
      in1 >> in2);  //R指令逻辑右移 
endmodule
