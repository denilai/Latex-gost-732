`timescale 1ns / 1ps
module outFunc(
    input [3:0] in,
    output reg [3:0] out
    );
	 always @(in)
	 case (in)
			4'h0: out<=4'hc;
			4'h1: out<=4'ha;
			4'h2: out<=4'h2;
			4'h3: out<=4'h5;
			4'h4: out<=4'hc;
			4'h5: out<=4'h7;
			4'h6: out<=4'hd;
			4'h7: out<=4'h2;
			4'h8: out<=4'h2;
			4'h9: out<=4'h7;
			4'ha: out<=4'h0;
			4'hb: out<=4'h3;
			4'hc: out<=4'h8;
			4'hd: out<=4'h4;
			4'he: out<=4'h4;
			4'hf: out<=4'h0;
		default: out<=4'h0;
	 endcase
endmodule
