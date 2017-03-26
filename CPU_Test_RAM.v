`timescale 1ns / 1ns

module CPU_Test_RAM(data,addr,enable,read,write);
input[7:0] data;
input[9:0] addr;
input enable;
input read,write;
reg[7:0] ram[10'h3ff:0];
assign data=(read&&enable)?ram[addr]:8'hzz;
always @(posedge write)
	begin
		ram[addr]<=data;
	end

endmodule
