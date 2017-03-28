`timescale 1ns / 1ps

module Full_Adder(in1,in2,cin,sumout,cout);
	parameter n;
	input[n-1:0] in1,in2;
	input cin;
	output[n-1:0] sumout;
	output cout;
	reg sumout,cout;
	assign {cout,sumout}=in1+in2+cin;
endmodule
