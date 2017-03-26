`timescale 1ns / 1ns

`include "CPU_Clk_Gen.v"
`include "CPU_ALU.v"
`include "CPU_Accumulator.v"
`include "CPU_Address.v"
`include "CPU_Counter.v"
`include "CPU_Data_Control.v"
`include "CPU_Instruction_Register.v"
`include "CPU_State_Machine.v"
`include "CPU_State_Machine_Controler.v"

module RISC_CPU_All(clk,rst,halt,rd,wr,addr,data,opcode,fetch,ir_addr,pc_addr);
input clk,rst;
output rd,wr,halt;
output[12:0] addr;
output[1:0] opcode;
output fetch;
output[12:0] ir_addr,pc_addr;
inout[7:0] data;
wire rst,halt;
wire[7:0] data;
wire[12:0] addr;
wire rd,wr;
wire clk,fetch,alu_enable;
wire[2:0] opcode;
wire[12:0] ir_addr,pc_addr;
wire[7:0] alu_out,accum;
wire zero,inc_pc,load_acc,load_pc,load_ir,data_enable,control_enable;

CPU_Clk_Gen m_clk_gen(.clk(clk),.reset(rst),.fetch(fetch),.alu_enable(alu_enable));
CPU_Instruction_Register m_register(.data(data),.enable(load_ir),.rst(rst),.clk(clk),.opc_iraddr({opcode,ir_addr}));
CPU_Accumulator m_accum(.data(data),.enable(load_acc),.clk(clk),.rst(rst),.accum(accum));
CPU_ALU m_alu(.data(data),.accum(accum),.clk(clk),.alu_enable(alu_enable),.op_code(opcode),.alu_out(alu_out),.zero(zero));
CPU_State_Machine_Controler m_machinectl(.clk(clk),.rst(rst),.fetch(fetch),.enable(control_enable));
CPU_State_Machine m_machine(.inc_pc(inc_pc),.load_acc(load_acc),.load_pc(load_pc),.rd(rd),.wr(wr),.load_ir(load_ir),
										.clk(clk),.datactl_enable(data_enable),.halt(halt),.zero(zero),.enable(conrtol_enable),
										.opcode(opcode));
CPU_Data_Control m_datactl(.in(alu_out),.data_enable(data_enable),.data(data));
CPU_Address m_addr(.fetch(fetch),.ir_addr(ir_addr),.pc_addr(pc_addr),.addr(addr));
CPU_Counter m_counter(.clk(inc_pc),.rst(rst),.ir_addr(ir_addr),.load(load_pc),.pc_addr(pc_addr));

endmodule