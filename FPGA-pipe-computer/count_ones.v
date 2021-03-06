//////////////////////////////////////////////////////////////////////////////
// 6:3 compressor as a 64x3b ROM -- three 6-LUTs
//
module c63(
    input [5:0] i,
    output reg [2:0] o);    // # of 1's in i

    always @* begin
        case (i)
        6'h00: o = 0; 6'h01: o = 1; 6'h02: o = 1; 6'h03: o = 2;
        6'h04: o = 1; 6'h05: o = 2; 6'h06: o = 2; 6'h07: o = 3;
        6'h08: o = 1; 6'h09: o = 2; 6'h0A: o = 2; 6'h0B: o = 3;
        6'h0C: o = 2; 6'h0D: o = 3; 6'h0E: o = 3; 6'h0F: o = 4;
        6'h10: o = 1; 6'h11: o = 2; 6'h12: o = 2; 6'h13: o = 3;
        6'h14: o = 2; 6'h15: o = 3; 6'h16: o = 3; 6'h17: o = 4;
        6'h18: o = 2; 6'h19: o = 3; 6'h1A: o = 3; 6'h1B: o = 4;
        6'h1C: o = 3; 6'h1D: o = 4; 6'h1E: o = 4; 6'h1F: o = 5;
        6'h20: o = 1; 6'h21: o = 2; 6'h22: o = 2; 6'h23: o = 3;
        6'h24: o = 2; 6'h25: o = 3; 6'h26: o = 3; 6'h27: o = 4;
        6'h28: o = 2; 6'h29: o = 3; 6'h2A: o = 3; 6'h2B: o = 4;
        6'h2C: o = 3; 6'h2D: o = 4; 6'h2E: o = 4; 6'h2F: o = 5;
        6'h30: o = 2; 6'h31: o = 3; 6'h32: o = 3; 6'h33: o = 4;
        6'h34: o = 3; 6'h35: o = 4; 6'h36: o = 4; 6'h37: o = 5;
        6'h38: o = 3; 6'h39: o = 4; 6'h3A: o = 4; 6'h3B: o = 5;
        6'h3C: o = 4; 6'h3D: o = 5; 6'h3E: o = 5; 6'h3F: o = 6;
        endcase
    end
endmodule

//////////////////////////////////////////////////////////////////////////////
// 36-bit bitcount
//
module counter(
    input [35:0] i,
    output [5:0] sum);  // # of 1's in i

    wire [2:0] c0500, c1106, c1712, c2318, c2924, c3530, c0, c1, c2;

    // add six bundles of six bits
    c63 c0500_(i[ 5: 0], c0500);
    c63 c1106_(i[11: 6], c1106);
    c63 c1712_(i[17:12], c1712);
    c63 c2318_(i[23:18], c2318);
    c63 c2924_(i[29:24], c2924);
    c63 c3530_(i[35:30], c3530);

	// sum the bits set in the [0], [1], and [2] bit positions separately
    c63 c0_({c0500[0],c1106[0],c1712[0],c2318[0],c2924[0],c3530[0]}, c0);
    c63 c1_({c0500[1],c1106[1],c1712[1],c2318[1],c2924[1],c3530[1]}, c1);
    c63 c2_({c0500[2],c1106[2],c1712[2],c2318[2],c2924[2],c3530[2]}, c2);
	assign sum = {2'b0,c0} + {1'b0,c1,1'b0} + {c2,2'b0};
endmodule
