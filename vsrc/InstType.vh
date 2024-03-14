//指令类型的独热码
parameter R_TYPE = 5;
parameter I_TYPE = 4;
parameter S_TYPE = 3;
parameter B_TYPE = 2;
parameter U_TYPE = 1;
parameter J_TYPE = 0;
//指令的类型分类
parameter R_TYPE_ALU = 7'b011_0011;  //R指令算术逻辑组
parameter I_TYPE_ALU = 7'b001_0011;  //I指令算术逻辑组
parameter I_TYPE_LOD = 7'b000_0011;  //I指令内存读取组
parameter I_TYPE_JMP = 7'b110_0111;  //J指令立即跳转组
parameter I_TYPE_ENV = 7'b111_0011;  //I指令环境调用组
parameter S_TYPE_STO = 7'b010_0011;  //S指令内存写回组
parameter B_TYPE_JMP = 7'b110_0011;  //B指令比较跳转组
parameter U_TYPE_LUI = 7'b011_0111;  //U指令LUI组
parameter U_TYPE_AUI = 7'b001_0111;  //U指令AUIPC组
parameter J_TYPE_JMP = 7'b110_1111;  //J指令立即跳转组
