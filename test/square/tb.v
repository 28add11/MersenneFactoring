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
	reg [31:0] x;
	wire [63:0] y;

	square #(32) squarer(
		.sys_clk(clk),
		.sys_rst_n(rst_n),
		.x(x),
		.y(y)
	);


endmodule
