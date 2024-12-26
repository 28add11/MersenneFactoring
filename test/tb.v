`default_nettype none
`timescale 1ns / 1ps

module tb();

	// FST testbench files now! no more vcd!
	initial begin
		$dumpfile("tb.fst");
		$dumpvars(0, tb);
	end

	// instantiate our divider!
	reg clk1;
	reg rst_n1;
	reg start;
	reg [31:0] dividend;
	reg [31:0] divisor;
	wire [31:0] remainder;
	wire data_ready;

	divider modCalculator(
		.sys_clk(clk1),
		.sys_rst_n(rst_n1),
		.start(start),
		.numerator(dividend),
		.denominator(divisor),
		.remainder(remainder),
		.finished(data_ready)
	);

	// Set up the squaring module

	reg clk2;
	reg rst_n2;
	reg [31:0] x;
	wire [63:0] y;

	square Square(
		.sys_clk(clk2),
		.sys_rst_n(rst_n2),
		.x(x),
		.y(y)
	);


endmodule
