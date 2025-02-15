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
	reg [31:0] exponent;
	reg [31:0] divisor;
	wire divisibility;
	wire data_ready;

	// instantiate our module
	mersenneFactoring mersenneFactoring(
		.sys_clk(clk),
		.sys_rst_n(rst_n),
		.start(start),
		.p(exponent),
		.d(divisor),
		.dividesBy(divisibility),
		.finished(data_ready)
	);

	reg clk2;
	reg rst_n2;
	reg [7:0] x;
	wire [15:0] y;

	square #(8) squarer(
		.sys_clk(clk2),
		.sys_rst_n(rst_n2),
		.x(x),
		.y(y)
	);


endmodule
