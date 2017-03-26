`timescale 1ns / 1ns

module CPU_State_Machine_Controler(enable,fetch,rst,clk);
input fetch,rst,clk;
output enable;
reg enable;
reg state;
always @(posedge clk)
begin
	if(rst)
		begin
			enable<=0;
		end
	else
		if(fetch)
			begin
				enable<=1;
			end
end


endmodule
