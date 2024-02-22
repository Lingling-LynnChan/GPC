#include <cstdint>
#include <iostream>
#include <random>
#ifndef _FAKE_VSCODE_LINT
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VMultiplier32.h"  // 替换为顶层模块的文件名
#else
// 欺骗代码提示，假装存在这些类
typedef volatile uint64_t vluint64_t;
class Verilated {
 public:
  Verilated() = default;
  ~Verilated() = default;
  static void commandArgs(int argc, char **argv) {}
  static void traceEverOn(bool b) {}
};
class VerilatedVcdC {
 public:
  VerilatedVcdC() = default;
  ~VerilatedVcdC() = default;
  void open(const char *filename) {}
  void close() {}
  void dump(vluint64_t i) {}
};
struct VMultiplier32 {
  uint32_t in1;
  uint32_t in2;
  uint64_t out;
  void eval() {}
  void final() {}
  void trace(VerilatedVcdC *vcd, int i) {}
};
#endif
void init(int argc, char **argv);
std::string i10to16(uint32_t i);
volatile uint32_t ram[256 * 1024 / 4];  // 256k
volatile uint32_t code_len;
vluint64_t main_time = 0;  // 仿真时间变量
int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);
  init(argc, argv);
  // 实例化顶层模块
  auto *top = new VMultiplier32;
  VerilatedVcdC *vcd = new VerilatedVcdC;
  top->trace(vcd, 999);
  vcd->open("build/trace.vcd");
  // 仿真开始
  std::cout << "====================sim start===========================\n";
  // 随机数
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<int32_t> distrib(0, 10);  // 范围
  int n = 20;                                               // 仿真次数
  while (n--) {
    top->in1 = distrib(gen);                       // 生成被乘数
    top->in2 = distrib(gen);                       // 生成乘数
    uint64_t ans = (uint64_t)top->in1 * top->in2;  // 计算值
    top->eval();                                   // 仿真值
    printf("%d*%d=%ld,%ld\n", top->in1, top->in2, *(int64_t *)&top->out,
           *(int64_t *)&ans);
    if (top->out != ans) {
      printf("ERROR: ANSWER IS %ld\n", *(int64_t *)&ans);
    }
  }

  std::cout << "====================sim end=============================\n";
  // 释放资源
  vcd->close();
  top->final();
  delete top;
  return 0;
}
void init(int argc, char **argv) {
  if (argc < 2) {
    std::cout << "Please input code file.\n" << std::endl;
    exit(1);
  }
  auto filename = argv[1];
  FILE *fp = fopen(filename, "rb");
  if (fp == NULL) {
    std::cout << "Open file failed.\n";
    exit(1);
  }
  fseek(fp, 0, SEEK_END);
  code_len = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  fread((void *)ram, 1, code_len, fp);
  code_len /= 4;
  fclose(fp);
  for (int i = 0; i < code_len; i++) {
    printf("0x%08x: ", 0x80000000 + i * 4);
    std::cout << i10to16(ram[i]) << std::endl;
  }
  std::cout << "load binary is ok\n";
}
std::string i10to16(uint32_t i) {
  char bin[33] = {0};
  sprintf(bin, "0x%08x", i);
  return std::string(bin);
}