`default_nettype none

module square #(
	parameter BITWIDTH=32,
) (
	input wire [BITWIDTH - 1:0] x,
	output reg [BITWIDTH * 2 - 1:0] y
);

	// Internal signals and data
	wire [BITWIDTH * 2 - 1:0] sum;
	wire [BITWIDTH * 2 - 1:0] selfProduct;
	wire [BITWIDTH * 2 - 1:0] crossProduct;

	genvar i;
	genvar j;

	// Self product
	for (i = 0; i < BITWIDTH; i = i + 1) begin
		assign selfProduct[i * 2] = x[i];
	end

	// Cross product
	for (i = 0; i < BITWIDTH; i = i + 1) begin
		for (j = i + 1; j < BITWIDTH; j = j + 1) begin
			assign crossProduct[i + j + 1] = (x[i] & x[j]);
		end
	end

	assign sum = selfProduct + crossProduct;
	
endmodule