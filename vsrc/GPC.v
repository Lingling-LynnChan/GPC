`timescale 1ns / 1ps

module GPC #(  //Gwen Processor Core
    INST_WIDTH = 32,
    WIDTH = 32,
    PC_START = 32'h80000000
) (
    input  wire                  clk,    //时钟信号
    input  wire                  rst,    //全局复位
    input  wire [INST_WIDTH-1:0] inst,   //返回的指令
    output wire [     WIDTH-1:0] pc,
    output wire                  ebreak
);

endmodule
