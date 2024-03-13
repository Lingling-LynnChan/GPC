`timescale 1ns / 1ps

module GPC_SCP32 #(  //Gwen Processor Core: Single Cycle Processor 32 bit
    INST_MAX = 32,
    WIDTH = 32,
    PC_START = 32'h80000000
) (
    input                 clk,   //时钟信号
    input                 rst,   //全局复位
    input  [INST_MAX-1:0] inst,  //返回的指令
    output [   WIDTH-1:0] pc
);
  ///连线和端口声明
  wire             regs_wen;  //寄存器组写使能
  wire [      4:0] regs_addrw;  //寄存器组写地址
  wire [      4:0] regs_addra;  //寄存器组读地址a
  wire [      4:0] regs_addrb;  //寄存器组读地址b
  wire [WIDTH-1:0] regs_dinw;  //寄存器组写数据
  wire [WIDTH-1:0] regs_dina;  //寄存器组读数据a
  wire [WIDTH-1:0] regs_dinb;  //寄存器组读数据b
  Regs #(
      .WIDTH(WIDTH),  //数据位宽
      .NR_REGS(32),  //寄存器数量
      .ADDR_WIDTH(5),  //lg(寄存器数量)
      .RESET_VAL(0)
  ) Regs_inst (
      .clk  (clk),
      .rst  (rst),
      .wen  (regs_wen),
      .addrw(regs_addrw),
      .addra(regs_addra),
      .addrb(regs_addrb),
      .dinw (regs_dinw),
      .douta(regs_dina),
      .doutb(regs_dinb)
  );
  PC32 #(
      .START_ADDR(PC_START),
  ) PC_inst (
      .clk(clk),
      .rst(rst),
      .ipc(),
      .imm(),
      .pc (pc)
  );
endmodule
