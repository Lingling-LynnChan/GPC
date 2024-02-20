`timescale 1ns / 1ps

module GPC_SCP32 #(  //Gwen Processor Core: Single Cycle Processor 32 bit
    INST_WIDTH = 32,
    WIDTH = 32,
    PC_START = 32'h80000000
) (
    input                   clk,    //时钟信号
    input                   rst,    //全局复位
    input  [INST_WIDTH-1:0] inst,   //返回的指令
    output [     WIDTH-1:0] pc,
    output                  ebreak
);
  ///连线和端口声明
  wire regs_wen;  //寄存器组写使能
  wire [4:0] regs_addrw;  //寄存器组写地址
  wire [4:0] regs_addra;  //寄存器组读地址a
  wire [4:0] regs_addrb;  //寄存器组读地址b
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
  wire jmp_en;  //是否跳转
  wire [WIDTH-1:0] jmp_target;  //跳转目标
  PC #(
      .WIDTH     (WIDTH),
      .START_ADDR(PC_START)
  ) PC_inst (
      .clk   (clk),
      .rst   (rst),
      .set_pc(jmp_en),
      .new_pc(jmp_target),
      .pc    (pc)
  );
  ///控制解码
  wire [ 6:0] opcode = inst[6:0];
  wire [ 2:0] funct3 = inst[14:12];
  wire [ 6:0] funct7 = inst[31:25];
  ///参数解码
  wire [ 4:0] rd = inst[11:7];
  wire [ 4:0] rs1 = inst[19:15];
  wire [ 4:0] rs2 = inst[24:20];
  wire [31:0] imm_i = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
  wire [31:0] imm_s = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
  wire [31:0] imm_b = {{20{inst[12]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
  wire [31:0] imm_u = {inst[31], inst[30:20], inst[19:12], 12'b0};
  wire [31:0] imm_j = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};

  

endmodule
