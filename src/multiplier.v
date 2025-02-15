// Nicholas West, 2025
/*
	* The multiplier, currently used only in the barret reduction component
	* Based off the squaring unit
	* Eventually, we want to make every barret reduction model use a single multiplier with control logit for arbitrary width
	* But for now it's not necessary.
*/

`default_nettype none

module multiplier #(
		parameter BITWIDTH=32
	) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire [BITWIDTH - 1:0] a,
	input wire [BITWIDTH - 1:0] b,
	output wire [BITWIDTH * 2 - 1:0] y
	);

	wire [BITWIDTH * 2 - 1:0] sum[$clog2(BITWIDTH):0][BITWIDTH - 1:0]; // I sincerely hope the synth tool gets rid of the unesssary wires

	generate
		genvar k, j;
		for (k = 0; k < BITWIDTH; k = k + 1) begin : gen_crossProduct
			wire [BITWIDTH - 1:0] intermediateCrossProd;

			// Calculate the actual product and left shift by appropriate amount
			// Extend bitwidth so we use the full width
			assign intermediateCrossProd = ({BITWIDTH{a[k]}} & b);
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
