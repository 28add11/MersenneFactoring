// Nicholas West, 2025
/*
	* This file creates the divider we use for calculating the modulus in our mersenne prime trial factoring
	* It uses the standard shift and subtract algorithm, modified to enable arbitrary bit widths
*/

`default_nettype none

module divider #(
		parameter BITWIDTH=32
	) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire start,
	input wire [BITWIDTH - 1:0] numerator,
	input wire [BITWIDTH - 1:0] denominator, 
	output reg [BITWIDTH - 1:0] remainder,
	output wire finished
	);

	// Despite calling this a divider its more of a modulo since we never return the quotient

	parameter WAIT = 1'b0;
	parameter DIVIDE = 1'b1;

	reg [BITWIDTH - 1:0] dividend;
	reg [BITWIDTH - 1:0] divisor;
	wire [BITWIDTH - 1:0] nextRemainder;

	reg state;
	// Minimum bit width to store value from 0 to BITWIDTH
	reg [$clog2(BITWIDTH) - 1:0] count;

	assign finished = ~state;
	assign nextRemainder = {remainder, dividend[count]};
	
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (start) begin // Initialize everything to starting values
			state <= DIVIDE;
			count <= BITWIDTH - 1;
			dividend <= numerator;
			divisor <= denominator;
			remainder <= 0;
		end
		if (state == DIVIDE) begin // Simple shift and subtract division algorithm
			// No matter if divisor can fit in remainder, add in the next bit of dividend
			// If it does happen to fit, subtract (this is where we would add a 1 to the quotient but we dont need that)
			if (nextRemainder >= divisor) begin
				remainder <= nextRemainder - divisor;
			end else begin
				remainder <= nextRemainder;
			end

			// End case
			if (count == 0) begin
				state <= WAIT;
			end

			count <= count - 1;
		end
	end

endmodule
