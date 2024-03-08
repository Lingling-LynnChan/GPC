module Multiplier32 (  //三十二位快速乘法器
    input  [31:0] in1,  //被乘数
    input  [31:0] in2,  //乘数
    output [63:0] out   //积
);
  //部分积(partial product)生成
  wire [31:0] partial[31:0];
  generate
    genvar i;
    for (i = 0; i < 32; i++) begin
      assign partial[i] = in2[i] ? in1 : 0;
    end
  endgenerate
  //使用3-2压缩分组
  

endmodule
