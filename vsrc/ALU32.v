`timescale 1ns / 1ps

module ALU32 (
    input         opc,    //独热码
    input         valid,  //是否由算术逻辑单元处理
    input  [31:0] in1,
    input  [31:0] in2,
    output [31:0] out
);

endmodule
