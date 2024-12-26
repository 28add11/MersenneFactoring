`default_nettype none

module square #(
		parameter BITWIDTH=32
	) (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire [BITWIDTH - 1:0] x,
	output reg [BITWIDTH * 2 - 1:0] y
	);

	// Internal signals and data
	wire [BITWIDTH * 2 - 1:0] sum;
	wire [BITWIDTH * 2 - 1:0] selfProduct;
	wire [BITWIDTH * 2 - 1:0] crossProduct;

	genvar i;
	genvar j;

	generate
	// Self product
	for (i = 0; i < BITWIDTH; i = i + 1) begin : gen_selfProduct
		assign selfProduct[i * 2] = x[i];
	end
	// Assign uninitialized bits to 0
	for (i = 1; i < BITWIDTH * 2; i = i + 2) begin : gen_selfProduct_pad
		assign selfProduct[i] = 0;
	end

	// Cross product
	for (i = 0; i < BITWIDTH; i = i + 1) begin : gen_crossProduct_outer
		for (j = i + 1; j < BITWIDTH; j = j + 1) begin : gen_crossProduct_inner
			assign crossProduct = ((x[i] & x[j]) << (i + j + 1)) + crossProduct;
		end
	end
	endgenerate
	// Assign uninitialized bits to 0
	assign crossProduct[BITWIDTH * 2 - 1] = 0;
	assign crossProduct[0] = 0; // Covered in self products
	assign crossProduct[1] = 0; // Covered in self products, 0 + 1 + 1 = 2

	assign sum = selfProduct + crossProduct;

	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (~sys_rst_n) begin
			y <= 0;
		end else begin
			y <= sum;
		end
	end
	
endmodule