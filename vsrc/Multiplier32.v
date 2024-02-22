`timescale 1ns / 1ps

module Multiplier32 (  //三十二位快速乘法器
    input  [31:0] in1,  //被乘数
    input  [31:0] in2,  //乘数
    output [63:0] out   //积
);

  generate
    genvar i;
    //输入层
    wire [63:0] nums[32];
    for (i = 0; i < 32; i = i + 1) begin : WALLACE_INPUT_0
      assign nums[i] = in2[i] ? ({32'b0, in1} << i) : 64'b0;
    end

    //第一层
    wire [63:0] w1[21];  //u11 v11 u12 v12 ... u1a v1a [NUMS[30]]
    for (i = 0; i < 10; i = i + 1) begin : WALLACE_LEVEL_1
      CSA3T2 #(
          .WIDTH(64)
      ) inst (
          .in1 (nums[i*3]),
          .in2 (nums[i*3+1]),
          .in3 (nums[i*3+2]),
          .out (w1[i*2]),
          .cout(w1[i*2+1])
      );
    end
    assign w1[20] = nums[30];

    //第二层
    wire [63:0] w2[15];  //u21 v21 u22 v22 ... u27 v27 [NUMS[31]]
    for (i = 0; i < 7; i = i + 1) begin : WALLACE_LEVEL_2
      CSA3T2 #(
          .WIDTH(64)
      ) inst (
          .in1 (w1[i*3]),
          .in2 (w1[i*3+1]),
          .in3 (w1[i*3+2]),
          .out (w2[i*2]),
          .cout(w2[i*2+1])
      );
    end
    assign w2[14] = nums[31];

    //第三层
    wire [63:0] w3[10];  //u31 v31 ... u35 v35
    for (i = 0; i < 5; i = i + 1) begin : WALLACE_LEVEL_3
      CSA3T2 #(
          .WIDTH(64)
      ) inst (
          .in1 (w2[i*3]),
          .in2 (w2[i*3+1]),
          .in3 (w2[i*3+2]),
          .out (w3[i*2]),
          .cout(w3[i*2+1])
      );
    end

    //第四层
    wire [63:0] w4[6];  //u41 v41 ... u43 v43
    for (i = 0; i < 3; i = i + 1) begin : WALLACE_LEVEL_4
      CSA3T2 #(
          .WIDTH(64)
      ) inst (
          .in1 (w3[i*3]),
          .in2 (w3[i*3+1]),
          .in3 (w3[i*3+2]),
          .out (w4[i*2]),
          .cout(w4[i*2+1])
      );
    end  //这里没连 w3[9]

    //第五层
    wire [63:0] w5[4];  //u51 v51 u52 v52
    for (i = 0; i < 2; i = i + 1) begin : WALLACE_LEVEL_5
      CSA3T2 #(
          .WIDTH(64)
      ) inst (
          .in1 (w4[i*3]),
          .in2 (w4[i*3+1]),
          .in3 (w4[i*3+2]),
          .out (w5[i*2]),
          .cout(w5[i*2+1])
      );
    end

    //第六层
    wire [63:0] w6[2];
    CSA3T2 #(
        .WIDTH(64)
    ) WALLACE_LEVEL_6_inst (
        .in1 (w5[0]),
        .in2 (w5[1]),
        .in3 (w5[2]),
        .out (w6[0]),
        .cout(w6[1])
    );  //这里没连 w5[3]

    //第七层
    wire [63:0] w7[2];
    CSA3T2 #(
        .WIDTH(64)
    ) WALLACE_LEVEL_7_inst (
        .in1 (w6[0]),
        .in2 (w6[1]),
        .in3 (w5[3]),
        .out (w7[0]),
        .cout(w7[1])
    );

    //第八层
    wire [63:0] w8[2];
    CSA3T2 #(
        .WIDTH(64)
    ) WALLACE_LEVEL_8_inst (
        .in1 (w7[0]),
        .in2 (w7[1]),
        .in3 (w3[9]),
        .out (w8[0]),
        .cout(w8[1])
    );
    //第九层: 输出
    Adder #(
        .WIDTH(64)
    ) adder64_out (
        .cin (1'b0),
        .in1 (w8[0]),
        .in2 (w8[1]),
        .out (out),
        .cout()
    );
    // wire c;
    // rdcla r1 (
    //     .in1(w8[0][31:0]),
    //     .in2(w8[1][31:0]),
    //     .cin(1'b0),
    //     .out(out[31:0]),
    //     .cout(c)
    // );
    // rdcla r2 (
    //     .in1(w8[0][63:32]),
    //     .in2(w8[1][63:32]),
    //     .cin(c),
    //     .out(out[63:32]),
    //     .cout()
    // );
  endgenerate


endmodule
//FA的v(cout)相对于CSA3T2，左移了一位。
