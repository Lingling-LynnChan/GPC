module WallaceTree8 #(  //WallaceTree: https://foxsen.github.io/archbase/%E8%BF%90%E7%AE%97%E5%99%A8%E8%AE%BE%E8%AE%A1.html#%E5%8D%8E%E8%8E%B1%E5%A3%AB%E6%A0%91
    WIDTH = 32
) (
    input  [WIDTH-1:0] in  [8],  //端口N输入
    input  [WIDTH-1:0] vin [6],  //水平C输入
    output [WIDTH-1:0] vout[6],  //水平C输出
    output [WIDTH-1:0] sout,     //S输出
    output [WIDTH-1:0] cout      //C输出
);
  //第一层
  wire [WIDTH-1:0] s1[3];
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst11 (
      .in1 (in[0]),
      .in2 (in[1]),
      .in3 (in[2]),
      .out (s1[0]),
      .cout(vout[0])
  );
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst12 (
      .in1 (in[3]),
      .in2 (in[4]),
      .in3 (in[5]),
      .out (s1[1]),
      .cout(vout[1])
  );
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst13 (
      .in1 (in[6]),
      .in2 (in[7]),
      .in3 ({WIDTH{1'b0}}),
      .out (s1[2]),
      .cout(vout[2])
  );
  //第二层
  wire [WIDTH-1:0] s2[2];
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst21 (
      .in1 (s1[0]),
      .in2 (s1[1]),
      .in3 (s1[2]),
      .out (s2[0]),
      .cout(vout[3])
  );
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst22 (
      .in1 (vin[0]),
      .in2 (vin[1]),
      .in3 (vin[2]),
      .out (s2[1]),
      .cout(vout[4])
  );
  //第三层
  wire [WIDTH-1:0] s3[1];
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst31 (
      .in1 (s2[0]),
      .in2 (s2[1]),
      .in3 (vin[3]),
      .out (s3[0]),
      .cout(vout[5])
  );
  //第四层
  CSA3T2 #(
      .WIDTH(WIDTH)
  ) inst41 (
      .in1 (s3[0]),
      .in2 (vin[4]),
      .in3 (vin[5]),
      .out (sout),
      .cout(cout)
  );
endmodule
