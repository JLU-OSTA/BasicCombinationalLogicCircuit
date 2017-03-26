`timescale 1ns / 1ns

module CPU_Accumulator(accum,data,enable,clk,rst);
output[7:0] accum;
input[7:0] data;
input enable,clk,rst;
reg[7:0] accum;
always @(posedge clk)
	begin
		if(rst)
			accum<=8'b00000000;
		else
			if(enable)
				begin
					accum<=data;
				end
	end
endmodule
