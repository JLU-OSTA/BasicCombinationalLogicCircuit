`timescale 1ns / 1ns

module CPU_Test_ROM(data,addr,read,enable);
output[7:0] data;
input[12:0] addr;
input read,enable;
reg[7:0] rom[13'h1fff:0];
wire[7:0] data;
assign data=(read&&enable)?rom[addr]:8'bzzzzzzzz;

endmodule
