// Nicholas West, 2025
/*
	* This file contains the core of the barret reduction algorithm
	* We don't calculate the constant or modulus bitwidth value here, that is done in the top level module
	* Based off my python implementation of the algorithm
	* Eventually I'll make this file support arbitrary width numbers
*/

`default_nettype none

/**
 * The barret reduction module
 * 
 * Numerator and denominator are the numbers we are dividing to get the remainder
 * R is the bitwidth of the denominator, multiplied by 2
 * Constant is the constant value we calculate in the top level module (const = (1 << r) // m)
 */
module barretReduce #(
	parameter BITWIDTH=32
) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire start,
	input wire [BITWIDTH - 1:0] numerator,
	input wire [BITWIDTH - 1:0] denominator,
	input wire [BITWIDTH - 1:0] R,
	input wire [BITWIDTH - 1:0] constant,
	output reg [BITWIDTH - 1:0] remainder
	);

	// Internal data and signals
	reg state;
	reg [BITWIDTH - 1:0] intermediate;
	wire [BITWIDTH - 1:0] tempResult;

	// Instantiate our multiplier
	// Wires here are for multiplexed input into multiplier
	// Saving space since having two 32x32 bit multipliers AND a squaring unit would be stupidly large
	wire [BITWIDTH - 1:0] a;
	wire [BITWIDTH - 1:0] b;
	wire [BITWIDTH * 2 - 1:0] y;

	multiplier #(
		.BITWIDTH(BITWIDTH)
	) mult (
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.a(a),
		.b(b),
		.y(y)
	);

	assign a = state ? intermediate : numerator;
	assign b = state ? denominator : constant;

	assign tempResult = numerator - y;

	always @(posedge sys_clk) begin
		if (!sys_rst_n) begin
			state <= 0;
		end else if (start) begin
			intermediate <= y >> R;
			state <= 1;
		end else if (state) begin
			remainder <= (tempResult >= denominator) ? tempResult - denominator: tempResult;
			state <= 0;
		end
	end
	
endmodule
