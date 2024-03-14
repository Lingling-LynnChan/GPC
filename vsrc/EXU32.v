`timescale 1ns / 1ps

module EXU32 #(  //EXecution Unit
    INST_MAX = 32,
    WIDTH    = 32
) (
    input  [      5:0] itype,
    input  [      6:0] opcode,
    input  [      2:0] funct3,
    input  [WIDTH-1:0] oldpc,      //源PC
    input  [WIDTH-1:0] in1,        //源1
    input  [WIDTH-1:0] in2,        //源2
    input  [WIDTH-1:0] dest,       //目的
    output [WIDTH-1:0] newpc,      //更新PC
    output             load_en,
    output [WIDTH-1:0] load_addr,
    output             store_en,
    output [WIDTH-1:0] store_addr
);
endmodule
