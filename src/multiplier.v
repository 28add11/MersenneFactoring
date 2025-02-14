// Nicholas West, 2025
/*
	* The multiplier, currently used only in the barret reduction component
	* Based off the squaring unit
	* Eventually, we want to make every barret reduction model use a single multiplier with control logit for arbitrary width
	* But for now it's not necessary.
*/

`default_nettype none

module multiply #(
		parameter BITWIDTH=32
	) (
	input wire [BITWIDTH - 1:0] a,
	input wire [BITWIDTH - 1:0] b,
	output wire [BITWIDTH * 2 - 1:0] y
	);

	wire [BITWIDTH * 2 - 1:0] sum[$clog2(BITWIDTH):0][BITWIDTH - 1:0]; // I sincerely hope the synth tool gets rid of the unesssary wires
	assign sum[0][BITWIDTH - 1] = 0; // Initialize unused to zero

	generate
		genvar k, j;
		for (k = 0; k < BITWIDTH - 1; k = k + 1) begin : gen_crossProduct
			wire [BITWIDTH - 1:0] intermediateCrossProd;

			// Calculate the actual product and left shift by appropriate amount
			// The arithmetic is a little weird, we have to extend x[k] to the full bitwidth, and also shift the range we're calculating
			// to prevent it from only using low bits
			assign intermediateCrossProd = (a[k] & b);
			assign sum[0][k] = intermediateCrossProd << k;
		end
		for (k = 1; k <= $clog2(BITWIDTH); k = k + 1) begin : adderTreeOuter
			for (j = 0; j < (BITWIDTH / (2**k)); j = j + 1) begin : adderTreeInner
				// k is our "layer" of the adder tree, while j is our "connection" in that layer
				assign sum[k][j] = sum[k - 1][2 * j] + sum[k - 1][2 * j + 1];
			end
		end
	endgenerate
	
	assign y = sum[$clog2(BITWIDTH)][0];

endmodule
