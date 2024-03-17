`timescale 1ns / 1ps

module GPC32 #(  //Gwen Processor Core: Single Cycle Processor 32 bit
    INST_MAX = 32,
    WIDTH = 32,  //数据位宽
    PC_START = 32'h8000_0000,
    NR_REGS = 32,  //寄存器数量
    ADDR_WIDTH = 5  //lg(寄存器数量)
) (
    input                 clk,   //时钟信号
    input                 rst,   //全局复位
    input  [INST_MAX-1:0] inst,  //返回的指令
    output [   WIDTH-1:0] pc
);
  ///连线和端口声明
  wire [      2:0] regsio;  //寄存器读写使能
  wire [WIDTH-1:0] addrd0;  //目的地址或B指令中的imm
  wire [WIDTH-1:0] addrs1;  //源1寄存器地址
  wire [WIDTH-1:0] addrs2;  //源2寄存器地址或imm
  wire [WIDTH-1:0] regs_dinw;  //寄存器组写数据w
  wire [WIDTH-1:0] regs_dina;  //寄存器组读数据a
  wire [WIDTH-1:0] regs_dinb;  //寄存器组读数据b
  wire [      9:0] fun;
  wire [      6:0] opcode;
  wire [WIDTH-1:0] alu_out;
  wire [      5:0] itype;
  wire             use_alu;
  wire [WIDTH-1:0] sin1;  //源1数据
  wire [WIDTH-1:0] sin2;  //源2数据
  wire [WIDTH-1:0] rdin;  //除ALU输入之外的其他输入
  //TODO: 实现EXU
  
  //模块连线
  assign sin1 = regsio[1] ? regs_dina : addrs1;
  assign sin2 = regsio[2] ? regs_dinb : addrs2;
  assign regs_dinw = use_alu ? alu_out : rdin;
  Regs #(
      .WIDTH     (WIDTH),
      .NR_REGS   (NR_REGS),
      .ADDR_WIDTH(ADDR_WIDTH),
      .RESET_VAL (0)
  ) Regs_inst (
      .clk  (clk),
      .rst  (rst),
      .addrw(regsio[0] ? addrd0[ADDR_WIDTH-1:0] : 0),
      .addra(regsio[1] ? addrs1[ADDR_WIDTH-1:0] : 0),
      .addrb(regsio[2] ? addrs2[ADDR_WIDTH-1:0] : 0),
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
  IDU32 #(
      .INST_MAX(INST_MAX),
      .WIDTH   (WIDTH)
  ) IDU32_inst (
      .inst (inst),
      .d0en (regsio[0]),
      .s1en (regsio[1]),
      .s2en (regsio[2]),
      .d0imm(addrd0),
      .s1   (addrs1),
      .s2imm(addrs2),
      .fun  (fun),
      .opcode(opcode),
      .itype(itype),
      .use_alu(use_alu)
  );
  ALU32 #(
      .WIDTH(WIDTH)
  ) ALU32_inst (
      .fun  (fun),
      .itype(itype),
      .in1  (sin1),
      .in2  (sin2),
      .out  (alu_out)
  );
endmodule
