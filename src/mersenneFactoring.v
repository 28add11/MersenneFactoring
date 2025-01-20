`default_nettype none

module mersenneFactoring #(
	parameter BITWIDTH=32
) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire start,
	input wire [BITWIDTH - 1:0] p,
	input wire [BITWIDTH - 1:0] d,
	output reg isPrime,
	output wire finished
);

	parameter WAIT=1'b0;
	parameter FACTOR=1'b01;

	reg state;

	reg [BITWIDTH - 1:0] denominator;
	reg [BITWIDTH - 1:0] exponent;
	reg [BITWIDTH - 1:0] workingNum;
	reg [$clog2(BITWIDTH) - 1:0] iterationCount;
	
	assign finished = ~state;

	wire [BITWIDTH * 2 - 1:0] squareResult;
	// Instantiate the squarer
	square square(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.x(workingNum),
		.y(squareResult)
	);


	wire divStart;
	wire divFinished;
	// Instantiate the divider
	divider div(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.start(divStart),
		.numerator((exponent[iterationCount] ? squareResult[BITWIDTH - 1:0] << 1 : squareResult[BITWIDTH - 1:0])), // Multiplication by 2, following the algorithm
		.denominator(denominator),
		.remainder(workingNum),
		.finished(divFinished)
	);

	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (~sys_rst_n) begin
			isPrime <= 0;
			iterationCount <= BITWIDTH - 1;
			state <= WAIT;
		end
		if (start) begin
			denominator <= d;
			exponent <= p;
			workingNum <= 1;
			iterationCount <= BITWIDTH - 1; // This can be optimized since leading 0s are useless
			divStart <= 1; // Start up the divider since we have it in an "if" block outside of here, plus 1 clock cycle bonus
			state <= FACTOR;
		end

		if (state == FACTOR) begin
			if (iterationCount == 0) begin
					// Since we're testing for 2^p - 1, we check if the remainder is 1 rather than 0
					isPrime <= (workingNum == 1) ? 1 : 0;
					state <= WAIT;
				end

				if (divFinished) begin // Since squaring is all combinational this works nicely (TODO: pipeline it more to push higher clocks)
				workingNum <= div.remainder;
				iterationCount <= iterationCount - 1;
				divStart <= 1;
			end
		end
				
	end
	
endmodule