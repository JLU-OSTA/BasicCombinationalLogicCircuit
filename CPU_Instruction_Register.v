`timescale 1ns / 1ns

module CPU_Instruction_Register(opc_iraddr,data,enable,clk,rst);
output[15:0] opc_iraddr;
input[7:0] data;
input enable,clk,rst;
reg[15:0] opc_iraddr;
reg state;
always @(posedge clk)
begin
	if(rst)
		begin
			opc_iraddr<=16'b0000000000000000;
			state<=1'b0;
		end
	else
		begin
			if(enable)
				begin
					casex(state)
						1'b0:
							begin
								opc_iraddr[15:8]<=data;
								state<=1;
							end
						1'b1:
							begin
								opc_iraddr[15:0]<=data;
								state<=0;
							end
						default:
							begin
								opc_iraddr[15:0]<=16'bxxxxxxxxxxxxxxxx;
								state<=1'bx;
							end
					endcase
				end
			else
				begin
					state<=1'b0;
				end
		end
end
endmodule
