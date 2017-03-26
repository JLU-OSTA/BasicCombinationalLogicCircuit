`timescale 1ns / 1ns

module CPU_Counter(pc_addr,ir_addr,load,clk,rst);
output[12:0] pc_addr;
input[12:0] ir_addr;
input clk,load,rst;
reg[12:0] pc_addr;
always @(posedge clk or posedge rst)
begin
	if(rst)
		begin
			pc_addr<=13'b0000000000000;
		end
	else
		if(load)
			begin
				pc_addr<=ir_addr;
			end
		else
			begin
				pc_addr<=pc_addr+1;
			end
end
endmodule
