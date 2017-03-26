`timescale 1ns / 1ns

module CPU_Clk_Gen(clk,reset,fetch,alu_enable);
input clk,reset;
output fetch,alu_enable;
wire clk,reset;
reg fetch,alu_enable;
reg[7:0] state;
parameter
	S1 = 8'b00000001,
	S2 = 8'b00000010,
	S3 = 8'b00000100,
	S4 = 8'b00001000,
	S5 = 8'b00010000,
	S6 = 8'b00100000,
	S7 = 8'b01000000,
	S8 = 8'b10000000,
	S0 = 8'b00000000;
always @(posedge clk)
	if(reset)
		begin
			fetch <= 0;
			alu_enable<=0;
			state<=S0;
		end
	else
		begin
			case(state)
				S1:
					begin
						alu_enable<=1;
						state<=S2;
					end
				S2:
					begin
						alu_enable<=0;
						state<=S3;
					end
				S3:
					begin
						alu_enable<=1;
						state<=S4;
					end
				S4:
					begin
						state<=S5;
					end
				S5:
					begin
						state<=S6;
					end
				S6:
					begin
						state<=S7;
					end
				S7:
					begin
						fetch<=0;
						state<=S8;
					end
				S8:
					begin
						state<=S1;
					end
				S0:	
					begin
						state<=S1;
					end
				default:		state<=S0;
			endcase
		end

endmodule
