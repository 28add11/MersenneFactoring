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
	reg [32:0] a;
	reg [32:0] b;
	wire [63:0] y;

	multiplier #(32) mult(
		.a(a),
		.b(b),
		.y(y)
	);


endmodule
