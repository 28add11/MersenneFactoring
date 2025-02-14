// Nicholas West, 2025
/*
	* This file describes a binary squaring module for use in the mersenne prime trial factoring algorithm
	* It uses the same general idea as a multiplier, but we only use half the "cells"
	* This is because the cross product is symmetric and we can save a lot of space by not calculating the same thing twice
*/

`default_nettype none

module square #(
		parameter BITWIDTH=32
	) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire [BITWIDTH - 1:0] x,
	output wire [BITWIDTH * 2 - 1:0] y
	);

	// Internal signals and data
	wire [BITWIDTH * 2 - 1:0] selfProduct;

	genvar i;

	generate
	// Self product
	for (i = 0; i < BITWIDTH; i = i + 1) begin : gen_selfProduct
		assign selfProduct[i * 2] = x[i];
	end
	// Assign uninitialized bits to 0
	for (i = 1; i < BITWIDTH * 2; i = i + 2) begin : gen_selfProduct_pad
		assign selfProduct[i] = 0;
	end
	endgenerate


	wire [BITWIDTH * 2 - 1:0] crossProdSum[$clog2(BITWIDTH):0][BITWIDTH - 1:0]; // I sincerely hope the synth tool gets rid of the unesssary wires
	assign crossProdSum[0][BITWIDTH - 1] = 0; // Initialize unused to zero

	generate
		genvar k, j;
		for (k = 0; k < BITWIDTH - 1; k = k + 1) begin : gen_crossProduct
			wire [BITWIDTH - 1:0] intermediateCrossProd;

			// Calculate the actual cross product and left shift by appropriate amount
			// The arithmetic is a little weird, we have to extend x[k] to the full bitwidth, and also shift the range we're calculating
			// to prevent it from only using low bits
			assign intermediateCrossProd = ({BITWIDTH{x[k]}} & (x[BITWIDTH - 1:k + 1] << k + 1));
			assign crossProdSum[0][k] = intermediateCrossProd << k;
		end
		for (k = 1; k <= $clog2(BITWIDTH); k = k + 1) begin : adderTreeOuter
			for (j = 0; j < (BITWIDTH / (2**k)); j = j + 1) begin : adderTreeInner
				// k is our "layer" of the adder tree, while j is our "connection" in that layer
				assign crossProdSum[k][j] = crossProdSum[k - 1][2 * j] + crossProdSum[k - 1][2 * j + 1];
			end
		end
	endgenerate

	
	assign y = selfProduct + (crossProdSum[$clog2(BITWIDTH)][0] << 1); // Cross prod * 2 to deal with symmetry in calculation and only calculating half

endmodule
