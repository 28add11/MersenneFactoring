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
	wire [BITWIDTH * 2 - 1:0] selfProduct;
	reg [BITWIDTH * 2 - 1:0] crossProduct;

	genvar i, j;

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


	integer k, l;

	// TODO: Look into making this adder tree more efficient than just naieve verilog implementation
	always @* begin
		crossProduct = 0; // Assign unused bits to zero and make it accumulate correctly
		for (k = 0; k < BITWIDTH; k = k + 1) begin : gen_crossProduct_outer
			for (l = k + 1; l < BITWIDTH; l = l + 1) begin : gen_crossProduct_inner
				crossProduct = crossProduct + ((x[k] & x[l]) << (k + l));
			end
		end
	end
	

	always @(posedge sys_clk or negedge sys_rst_n) begin
		if (~sys_rst_n) begin
			y <= 0;
		end else begin
			y <= selfProduct + (crossProduct << 1);
		end
	end
	
endmodule
