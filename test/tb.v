`default_nettype none
`timescale 1ns / 1ps

module tb();

	// If this is commented out in the repo it's because I don't want a terrabyte of VCD garbage
	/*
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(0, tb);
	end
	*/

	// instantiate our divider!
	reg clk;
	reg rst_n;
	reg start;
	reg [31:0] dividend;
	reg [31:0] divisor;
	wire [31:0] remainder;
	wire data_ready;

	divider modCalculator(
		.sys_clk(clk),
		.sys_rst_n(rst_n),
		.start(start),
		.numerator(dividend),
		.denominator(divisor),
		.remainder(remainder),
		.finished(data_ready)
	);

endmodule
