#include <cstdint>
#include <iostream>
#include <random>
#define NAME VCSA4T2
#ifndef _FAKE_VSCODE_LINT
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "VCSA4T2.h"  // 替换为顶层模块的文件名
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
  uint32_t cin;
  uint32_t in1;
  uint32_t in2;
  uint32_t in3;
  uint32_t in4;
  uint32_t out;
  uint32_t cout;
  uint32_t carry;
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
#ifdef Multiplier32
  int32_t errnum = 0;  // 错误次数
  // 随机数
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint32_t> distrib(0, UINT32_MAX);  // 范围
  int n = 1;  // 仿真次数
  uint32_t hf[2];
  uint64_t max = UINT32_MAX;
  uint32_t min = max - 1000;
  while (n--) {
    for (uint64_t i = min; i <= max; i++) {
      for (uint64_t j = i; j <= max; j++) {
        // hf[0] = distrib(gen);
        hf[0] = i;
        top->in1 = hf[0];  // 生成in1
        // hf[1] = distrib(gen);
        hf[1] = j;
        top->in2 = hf[1];  // 生成in2
        top->eval();
        uint64_t ans = (uint64_t)hf[0] * hf[1];  // 标准结果
        if (top->out != ans) {  // 比较仿真结果是否正确
          errnum++;
          printf("UNSG: %u * %u = %lu\n", hf[0], hf[1], top->out);
          printf("ERROR ANSWER: %lu\n", ans);
        }
      }
    }
  }
  printf("HAS %d ERROR(s)\n", errnum);
#else
  uint64_t cin = 1;
  uint64_t ins[4] = {UINT32_MAX, UINT32_MAX, 0, UINT32_MAX};
  top->in1 = ins[0];
  top->in2 = ins[1];
  top->in3 = ins[2];
  top->in4 = ins[3];
  top->cin = cin;
  top->eval();
  uint64_t out = top->out;
  uint64_t cout = top->cout;
  uint64_t carry = top->carry;
  uint64_t sum = (cout << 1) + out + (carry << 32);
  uint64_t ans = ins[0] + ins[1] + ins[2] + ins[3] + cin;
  printf("ANSWER IS %s: (%lu)|(%lu)\n", sum == ans ? "TRUE" : "FALSE", sum,
         ans);
#endif
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