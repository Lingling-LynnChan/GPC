module Multiplier32 (  //三十二位快速乘法器
    input  [31:0] in1,  //被乘数
    input  [31:0] in2,  //乘数
    output [63:0] out   //积
);
  generate
    //INFO: 部分积(partial product)
    wire [31:0] partial[31:0];
    genvar i;
    for (i = 0; i < 32; i++) begin
      //这里的部分积保留了位信息
      assign partial[i] = in2[i] ? in1 : 0;
    end
    //INFO: 使用3-2压缩分组
    //共32个数，可以分为 3*10+2 --> 10个S+10个C+2个原样输出(22个)
    wire [33:0] sout_level_1[9:0];
    wire [33:0] cout_level_1[9:0];
    for (i = 0; i < 10; i++) begin
      CSA3T2 #(
          .WIDTH(34)  //3个32位错位加
      ) CSA3T2_inst (
          .in1 ({2'b0, partial[i*3]}),
          .in2 ({1'b0, partial[i*3+1], 1'b0}),
          .in3 ({partial[i*3+2], 2'b0}),
          .out (sout_level_1[i]),
          .cout(cout_level_1[i])
      );
    end
    //共22个数，可以分为 3*7+1 --> 7个S+7个C+1个原样输出
    //二次分组成 3*(3*2)+(2+1)+1，(2+1)是因为有是保留的原样输出
    wire [36:0] sout_level_2[6:0];
    wire [36:0] cout_level_2[6:0];
    for (i = 0; i < 3; i++) begin
      CSA3T2 #(
          .WIDTH(37)  //三个34位错位加，其中一个错了两位
      ) CSA3T2_inst1 (
          .in1 ({3'b0, sout_level_1[i*3]}),
          .in2 ({2'b0, cout_level_1[i*3], 1'b0}),
          .in3 ({sout_level_1[i*3+1], 3'b0}),
          .out (sout_level_2[i*2]),
          .cout(cout_level_2[i*2])
      );
      CSA3T2 #(
          .WIDTH(37)
      ) CSA3T2_inst2 (
          .in1 ({3'b0, cout_level_1[i*3+1]}),
          .in2 ({1'b0, sout_level_1[i*3+2], 2'b0}),
          .in3 ({cout_level_1[i*3+2], 3'b0}),
          .out (sout_level_2[i*2+1]),
          .cout(cout_level_2[i*2+1])
      );
    end
    //特例
    CSA3T2 #(
        .WIDTH(37)
    ) CSA3T2_inst2 (
        .in1 ({3'b0, cout_level_1[9]}),
        .in2 ({2'b0, sout_level_1[9], 1'b0}),
        .in3 ({2'b0, partial[30], 3'b0}),
        .out (sout_level_2[6]),
        .cout(cout_level_2[6])
    );
  endgenerate
endmodule
