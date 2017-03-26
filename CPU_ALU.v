`timescale 1ns /1ns

module CPU_ALU(alu_out,zero,data,accum,alu_enable,clk,op_code);
output[7:0] alu_out;
output zero;
input[7:0] data,accum;
input[2:0] op_code;
input alu_enable,clk;
reg[7:0] alu_out;
parameter
	HLT = 3'b000,	//�رո�λ
	SKZ = 3'b001,	//λ�Ʋ���
	ADD = 3'b010,	//�����ӷ�
	AND = 3'b011,	//��λȡ��
	XOR = 3'b100,	//��λ���
	LDA = 3'b101,	//ȡ��
	STA = 3'b110,	//����
	JMP = 3'b111;	//��ת
assign zero = ! accum;
always @(posedge clk)
	begin
		if(alu_enable)
			begin
				casex(op_code)
					HLT:
						begin
							alu_out<=accum;
						end
					SKZ:
						begin
							alu_out<=accum;
						end
					ADD:
						begin
							alu_out<=data+accum;
						end
					AND:
						begin
							alu_out<=data&accum;
						end
					XOR:
						begin
							alu_out<=data^accum;
						end
					LDA:
						begin
							alu_out<=data;
						end
					STA:
						begin
							alu_out<=accum;
						end
					JMP:
						begin
							alu_out<=accum;
						end
					default:
						begin
							alu_out<=8'bxxxxxxxx;
						end
				endcase
			end
		end
endmodule
