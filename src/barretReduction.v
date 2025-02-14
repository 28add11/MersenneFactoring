// Nicholas West, 2025
/*
	* This file contains the core of the barret reduction algorithm
	* We don't calculate the constant or modulus bitwidth value here, that is done in the top level module
	* Based off my python implementation of the algorithm
	* Eventually I'll make this file support arbitrary width numbers
*/

`default_nettype none

module barretReduce #(
	parameter BITWIDTH=32
) (
	input wire [BITWIDTH - 1:0] numerator,
	input wire [BITWIDTH - 1:0] R,
	input wire [BITWIDTH - 1:0] constant,
	output reg [BITWIDTH - 1:0] remainder
	);


	
endmodule