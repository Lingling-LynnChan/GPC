`timescale 1ns / 1ps

module Regs #(
    WIDTH = 32,
    NR_REGS = 32,
    ADDR_WIDTH = 5,
    RESET_VAL = 0
) (
    input clk,  //时钟
    input rst,  //复位
    input wen,  //写使能
    input [ADDR_WIDTH-1:0] addrw,  //写地址
    input [ADDR_WIDTH-1:0] addra,  //读地址a
    input [ADDR_WIDTH-1:0] addrb,  //读地址b
    input [WIDTH-1:0] dinw,  //写数据
    output [WIDTH-1:0] douta,  //读输出a
    output [WIDTH-1:0] doutb  //读输出b
);
  wire [WIDTH-1:0] douts[NR_REGS];  //单个寄存器输出
  wire [NR_REGS*(ADDR_WIDTH+WIDTH)-1:0] lut;  //总输出线
  parameter WD = ADDR_WIDTH + WIDTH;
  begin
    Reg #(  //zero寄存器
        .WIDTH(WIDTH),
        .RESET_VAL(0)
    ) Reg_0 (
        .clk (clk),
        .rst (rst),
        .din (dinw),
        .wen (0),
        .dout(douts[0])
    );
    wire [ADDR_WIDTH-1:0] i0 = 0;
    assign lut[WD-1:0] = {i0, douts[0]};
  end
  generate
    genvar i;
    for (i = 1; i < NR_REGS; i = i + 1) begin : Reg_Gen
      Reg #(
          .WIDTH(WIDTH),
          .RESET_VAL(RESET_VAL)
      ) inst (
          .clk (clk),
          .rst (rst),
          .din (dinw),
          .wen (wen && (addrw == i)),
          .dout(douts[i])
      );
      wire [ADDR_WIDTH-1:0] iN = i;
      assign lut[(WD*(i+1)-1)-:WD] = {iN, douts[i]};
    end
  endgenerate
  //读输出a
  Mux #(
      .NR_KEY(NR_REGS),
      .KEY_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(WIDTH)
  ) mux_outa (
      .out(douta),
      .sel(addra),
      .def(0),
      .lut(lut)
  );
  //读输出b
  Mux #(
      .NR_KEY(NR_REGS),
      .KEY_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(WIDTH)
  ) mux_outb (
      .out(doutb),
      .sel(addrb),
      .def(0),
      .lut(lut)
  );
endmodule  //Regs
