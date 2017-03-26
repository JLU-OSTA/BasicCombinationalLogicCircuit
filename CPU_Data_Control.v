`timescale 1ns / 1ns

module CPU_Data_Control(data,in,data_enable);
output[7:0] data;
input[7:0] in;
input data_enable;
assign data = (data_enable)?in:8'bzzzzzzzz;

endmodule
