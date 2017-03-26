`timescale 1ns / 1ns

`include "RISC_CPU_All.v"
`include "CPU_Test_RAM.v"
`include "CPU_Test_ROM.v"
`include "CPU_Address_Decoder.v"

`define PERIOD 100

module CPC_TopSim;
reg reset_require,clk;
integer test;
reg[24:0] array;
reg[12:0] PC_addr,IR_addr;
wire[7:0] data;
wire[12:0] addr;
wire rd,wr,halt,ram_select,rom_select;
wire[2:0] opcode;
wire fetch;
wire[12:0] ir_addr,pc_addr;
RISC_CPU_All test_cpu(.clk(clk),.rst(rst),.halt(halt),.rd(rd),.wr(wr),.addr(addr),
								.data(data),.opcode(opcode),.fetch(fetch),.ir_addr(ir_addr),.pc_addr(pc_addr));
CPU_Test_RAM test_ram(.addr(addr[9:0]),.read(rd),.write(wr),.enable(ram_select),.data(data));
CPU_Test_ROM test_rom(.addr(addr),.read(rd),.enable(rom_select),.data(data));
CPU_Address_Decoder test_addr_decoder(.addr(addr),.ram_select(ram_select),.rom_select(rom_select));
initial
begin
	clk=1;
	$timeformat(-9,1,"ns",12);
	display_debug_message;
	sys_reset;
	test1;
	$stop;
	test2;
	$stop;
	test3;
	$finish;	
end

task display_debug_message;
begin
	$display("\n************************************");
	$display("\nThe Following is Debug Tasks");
	$display("\nMade by JLU-OSTA");
	$display("\nPrograms refer to BHU's book");
	$display("\n1.Load the 1st diagnostic program;");
	$display("\n2.Load the 2nd diagnostic program;");
	$display("\n3.Load the Fibonacci program.");
	$display("\n************************************");
end
endtask

task test1;
begin
	test=0;
	disable MONITOR;
	$readmemb("test1.pro",test_rom.rom);
	$display("ROM loaded...");
	$readmemb("test1.dat",test_ram.ram);
	$display("RAM loaded...");
	# 1 test=1;
	# 14800  ;
	sys_reset;
end
endtask

task test2;
begin
	test=0;
	disable MONITOR;
	$readmemb("test2.pro",test_rom.rom);
	$display("ROM loaded...");
	$readmemb("test2.dat",test_ram.ram);
	$display("RAM loaded...");
	# 1 test=2;
	# 11600  ;
	sys_reset;
end
endtask

task test3;
begin
	test=0;
	disable MONITOR;
	$readmemb("test3.pro",test_rom.rom);
	$display("ROM loaded...");
	$readmemb("test3.dat",test_ram.ram);
	$display("RAM loaded...");
	# 1 test=3;
	# 94000  ;
	sys_reset;
end
endtask

task sys_reset;
begin
	reset_require=0;
	# (`PERIOD*0.7) reset_require=1;
	# (1.5*`PERIOD) reset_require=0;
end
endtask

always @(test)
	begin:MONITOR
		case(test)
			1:
				begin
					$display("\n***RUNNING RISC CPU Test1 - The Basic Diagnostic***");
					$display("\n	TIME	PC	INSTR	ADDR	DATA	");
					$display("\n	-------------	-------	-----------	----------	------------");
					while(test==1)
						@(test_cpu.pc_addr)
						if((test_cpu.pc_addr%2==1)&&(test_cpu.fetch==1))
							begin
								# 60	PC_addr<=test_cpu.pc_addr-1;
										IR_addr<=test_cpu.ir_addr;
								# 340 $strobe("%t	%h	%s	%h	%h",$time,PC_addr,array,IR_addr,data);
							end
				end
			2:
				begin
					$display("\n***RUNNING RISC CPU Test2 - The Advanced Diagnostic***");
					$display("\n	TIME	PC	INSTR	ADDR	DATA	");
					$display("\n	-------------	-------	-----------	----------	------------");
					while(test==2)
						@(test_cpu.pc_addr)
						if((test_cpu.pc_addr%2==1)&&(test_cpu.fetch==1))
							begin
								# 60	PC_addr<=test_cpu.pc_addr-1;
										IR_addr<=test_cpu.ir_addr;
								# 340 $strobe("%t	%h	%s	%h	%h",$time,PC_addr,array,IR_addr,data);
							end
				end
			3:
				begin
					$display("\n***RUNNING RISC CPU Test3 - The Fibonacci Calculator***");
					$display("\n	TIME	FIBONACCI NUMBER	");
					$display("\n	-------------	-------------------------");
					while(test==3)
						begin
							wait(test_cpu.opcode==3'h1)
							$strobe("%t	%d",$time,test_ram.ram[10'h2]);
							wait(test_cpu.opcode!=3'h1);
						end
				end
		endcase
	end

always @(posedge halt)
	begin
		#500
		$display("\n***************************************");
		$display("\nThe HALT instruction is processing!!!");
		$display("\n***************************************");
	end

always #(`PERIOD/2) clk=~clk;

always @(test_cpu.opcode)
	case(test_cpu.opcode)
		3'b000:
			begin
				array="HLT";
			end
		3'b001:
			begin
				array="SKZ";
			end
		3'b010:
			begin
				array="ADD";
			end
		3'b011:
			begin
				array="AND";
			end
		3'b100:
			begin
				array="XOR";
			end
		3'b101:
			begin
				array="LDA";
			end
		3'b110:
			begin
				array="STA";
			end
		3'b111:
			begin
				array="JMP";
			end
		default:
			begin
				array="???";
			end
	endcase
endmodule
