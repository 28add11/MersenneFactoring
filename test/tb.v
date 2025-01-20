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
	wire primality;
	wire data_ready;

	// instantiate our module
	mersenneFactoring mersenneFactoring(
		.sys_clk(clk),
		.sys_rst_n(rst_n),
		.start(start),
		.p(exponent),
		.d(divisor),
		.isPrime(primality),
		.finished(data_ready)
	);


endmodule
