`default_nettype none
`timescale 1ns / 1ps

module tb();

	// FST testbench files now! no more vcd!
	initial begin
		$dumpfile("tb.fst");
		$dumpvars(0, tb);
	end

	reg clk;
	reg rst_n;
	reg start;
	reg [31:0] numerator;
	reg [31:0] denominator;
	reg [31:0] R;
	reg [31:0] constant;
	wire [31:0] remainder;

	barretReduce #(32) br(
		.sys_clk(clk),
		.sys_rst_n(rst_n),
		.start(start),
		.numerator(numerator),
		.denominator(denominator),
		.R(R),
		.constant(constant),
		.remainder(remainder)
	);


endmodule
