module Multiplier32 (  //三十二位快速乘法器
    input  [31:0] in1,  //被乘数
    input  [31:0] in2,  //乘数
    output [63:0] out   //积
);
  generate
    genvar i;
    //INFO: 部分积(partial product)
    wire [31:0] partial[31:0];
    for (i = 0; i < 32; i++) begin
      //这里的部分积保留了位信息
      assign partial[i] = in2[i] ? in1 : 0;
    end
    //INFO: 使用3-2压缩分组
    //共32个数，可以分为 3*10+2 --> 10个S+10个C+2个原样输出(22个)
    wire [33:0] sout_level_1[9:0];
    wire [32:0] cout_level_1[9:0];
    for (i = 0; i < 10; i++) begin
      CSA3T2 #(
          .WIDTH(34)  //3个错位32位相加，需要34位来容纳
      ) CSA3T2_inst (
          .in1 ({2'b0, partial[i*3]}),
          .in2 ({1'b0, partial[i*3+1], 1'b0}),
          .in3 ({partial[i*3+2], 2'b0}),
          .out (sout_level_1[i]),
          .cout({cout_level_1[i], 1'bz})
      );
    end
    //共22个数，可以分为 3*7+1 --> 7个S+7个C+1个原样输出
  endgenerate
endmodule
