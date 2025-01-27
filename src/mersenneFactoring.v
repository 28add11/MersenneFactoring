// Nicholas West, 2025
/*
	* This file implements the mersenne prime trial factoring algorithm using our custom divider and custom squarer
	* The algorithm used can be found at https://www.mersenne.org/various/math.php#trial_factoring 
*/

`default_nettype none

module mersenneFactoring #(
	parameter BITWIDTH=32
) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire start,
	input wire [BITWIDTH - 1:0] p,
	input wire [BITWIDTH - 1:0] d,
	output reg dividesBy,
	output wire finished
);

	parameter WAIT=0;
	parameter FACTOR=1;

	reg state;

	reg [BITWIDTH - 1:0] denominator;
	reg [BITWIDTH - 1:0] exponent;
	reg [BITWIDTH - 1:0] workingNum;
	reg [$clog2(BITWIDTH):0] iterationCount; // Not subtracting by 1 since we will detect overflow with the top bit then stop
	
	assign finished = ~state;

	wire [BITWIDTH * 2 - 1:0] squareResult;
	// Instantiate the squarer
	square square(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.x(workingNum),
		.y(squareResult)
	);

	reg divReady;
	reg divStart;
	wire divFinished;
	wire [BITWIDTH - 1:0] divResult;
	// Instantiate the divider
	divider div(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.start(divStart),
		.numerator((exponent[iterationCount] ? squareResult[BITWIDTH - 1:0] << 1 : squareResult[BITWIDTH - 1:0])), // Multiplication by 2, following the algorithm
		.denominator(denominator),
		.remainder(divResult),
		.finished(divFinished)
	);

	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (~sys_rst_n) begin
			dividesBy <= 0;
			iterationCount <= BITWIDTH - 1;
			state <= WAIT;
		end
		if (start) begin
			denominator <= d;
			exponent <= p;
			workingNum <= 1;
			iterationCount <= BITWIDTH - 1; // This can be optimized since leading 0s are useless
			divStart <= 1;
			state <= FACTOR;
		end

		if (state == FACTOR) begin
			if (iterationCount[$clog2(BITWIDTH)] == 1) begin
					// Since we're testing for 2^p - 1, we check if the remainder is 1 rather than 0
					dividesBy <= (workingNum == 1) ? 1 : 0;
					state <= WAIT;
			end
			if (divFinished) begin // Since squaring is all combinational this works nicely (TODO: pipeline it more to push higher clocks)
				workingNum <= divResult;
				divReady <= 1;
				if (~divReady) begin
					divStart <= 1;
				iterationCount <= iterationCount - 1;
			end
			end else begin
				divStart <= 0;
				divReady <= 0;
			end
		end
				
	end
	
endmodule