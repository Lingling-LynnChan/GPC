#include <cstdint>
#include <iostream>
#include <random>
#define NAME VMultiplier32
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
struct NAME {
  uint32_t in1;
  uint32_t in2;
  uint32_t cin;
  uint32_t out;
  uint32_t cout;
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
  auto *top = new NAME;
  VerilatedVcdC *vcd = new VerilatedVcdC;
  top->trace(vcd, 999);
  vcd->open("build/trace.vcd");
  // 仿真开始
  std::cout << "====================sim start===========================\n";
  int32_t errnum = 0;  // 错误次数
  if (true) {
    // 随机数
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint32_t> distrib(0, UINT32_MAX);  // 范围
    int n = 1;  // 仿真次数
    uint32_t hf[2];
    while (n--) {
      for (uint64_t i = 0; i < UINT32_MAX; i++) {
        for (uint64_t j = i; j < UINT32_MAX; j++) {
          // hf[0] = distrib(gen);
          hf[0] = i;
          top->in1 = hf[0];  // 生成in1
          // hf[1] = distrib(gen);
          hf[1] = j;
          top->in2 = hf[1];  // 生成in2
          top->eval();
          uint32_t ans = hf[0] * hf[1];
          if (top->out != ans) {
            errnum++;
            printf("UNSG: %u * %u = %lu\n", hf[0], hf[1], top->out);
            printf("ERROR ANSWER!!!\n");
          }
        }
      }
    }
    printf("HAS %d ERROR(s)\n", errnum);
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