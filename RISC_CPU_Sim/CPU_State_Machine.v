`timescale 1ns / 1ns

module CPU_State_Machine(inc_pc,load_acc,load_pc,rd,wr,load_ir,datactl_enable,halt,clk,zero,enable,opcode);
output inc_pc,load_pc,rd,wr,load_ir,load_acc;
output datactl_enable,halt;
input clk,zero,enable;
input[2:0] opcode;
reg inc_pc,load_acc,load_pc,rd,wr,load_ir;
reg datactl_enable,halt;
reg[2:0] state;
parameter
	HLT = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STA = 3'b110,
	JMP = 3'b111;
always @(negedge clk)
	begin
		if(!enable)
			begin
				state<=3'b000;
				{inc_pc,load_acc,load_pc,rd}<=4'b0000;
				{wr,load_ir,datactl_enable,halt}<=4'b0000;
			end
		else
			begin
				control_cycle;
			end
	end

//This is task of control cycle
task control_cycle;
	begin
		casex(state)
			3'b000:
				begin
					{inc_pc,load_acc,load_pc,rd}<=4'b0001;
					{wr,load_ir,datactl_enable,halt}<=4'b0100;
					state<=3'b001;
				end
			3'b001:
				begin
					{inc_pc,load_acc,load_pc,rd}<=4'b1001;
					{wr,load_ir,datactl_enable,halt}<=4'b0100;
					state<=3'b010;
				end
			3'b010:
				begin
					{inc_pc,load_acc,load_pc,rd}<=4'b0000;
					{wr,load_ir,datactl_enable,halt}<=4'b0000;
					state<=3'b011;
				end
			3'b011:	//Start analysing instruction
				begin
					if(opcode==HLT)
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b1000;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					else
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b1000;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					state<=3'b100;
				end
			3'b100:
				begin
					if(opcode==JMP)
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b0010;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					else
						begin
							if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA)
								begin
									{inc_pc,load_acc,load_pc,rd}<=4'b0001;
									{wr,load_ir,datactl_enable,halt}<=4'b0000;
								end
							else
								if(opcode==STA)
									begin
										{inc_pc,load_acc,load_pc,rd}<=4'b0000;
										{wr,load_ir,datactl_enable,halt}<=4'b0010;
									end
								else
									begin
										{inc_pc,load_acc,load_pc,rd}<=4'b0000;
										{wr,load_ir,datactl_enable,halt}<=4'b0000;
									end
						end
						state<=3'b101;
				end
			3'b101:
				begin
					if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA)
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b0101;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					else
						if(opcode==SKZ&&zero==1)
							begin
								{inc_pc,load_acc,load_pc,rd}<=4'b1000;
								{wr,load_ir,datactl_enable,halt}<=4'b0000;
							end
						else
							if(opcode==JMP)
								begin
									{inc_pc,load_acc,load_pc,rd}<=4'b1010;
									{wr,load_ir,datactl_enable,halt}<=4'b0000;
								end
							else
								if(opcode==STA)
									begin
										{inc_pc,load_acc,load_pc,rd}<=4'b0000;
										{wr,load_ir,datactl_enable,halt}<=4'b1010;
									end
								else
									begin
										{inc_pc,load_acc,load_pc,rd}<=4'b0000;
										{wr,load_ir,datactl_enable,halt}<=4'b0000;
									end
					state<=3'b110;
				end
			3'b110:
				begin
					if(opcode==STA)
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b0000;
							{wr,load_ir,datactl_enable,halt}<=4'b0010;
						end
					else
						if(opcode==ADD||opcode==AND||opcode==XOR||opcode==LDA)
							begin
								{inc_pc,load_acc,load_pc,rd}<=4'b0001;
								{wr,load_ir,datactl_enable,halt}<=4'b0000;
							end
						else
							begin
								{inc_pc,load_acc,load_pc,rd}<=4'b0000;
								{wr,load_ir,datactl_enable,halt}<=4'b0000;
							end
					state<=3'b111;
				end
			3'b111:
				begin
					if(opcode==SKZ&&zero==1)
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b1000;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					else
						begin
							{inc_pc,load_acc,load_pc,rd}<=4'b0000;
							{wr,load_ir,datactl_enable,halt}<=4'b0000;
						end
					state<=3'b000;
				end
			default:
				begin
					{inc_pc,load_acc,load_pc,rd}<=4'b0000;
					{wr,load_ir,datactl_enable,halt}<=4'b0000;
					state<=3'b000;
				end	

		endcase
	end
endtask
endmodule
