`timescale 1ns / 1ps

module Full_Adder(in1,in2,cin,sumout,cout);
	input[0:0] in1,in2,cin;
	output[0:0] sumout,cout;
	reg sumout,cout;
	initial
		fork
			assign sumout=(in1^in2)^in2;
			assign cout=((in1^in2)&in2)|(in1&in2);
		join
endmodule
