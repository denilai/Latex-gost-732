`timescale 1ns / 1ps

module beheviour(
	input[3:0]  X,
	output reg [3:0] Y
    );
	 always@(X)
		case(X)
			4'h0: Y<=4'hc;
			4'h1: Y<=4'ha;
			4'h2: Y<=4'h2;
			4'h3: Y<=4'h5;
			4'h4: Y<=4'hc;
			4'h5: Y<=4'h7;
			4'h6: Y<=4'hd;
			4'h7: Y<=4'h2;
			4'h8: Y<=4'h2;
			4'h9: Y<=4'h7;
			4'ha: Y<=4'h0;
			4'hb: Y<=4'h3;
			4'hc: Y<=4'h8;
			4'hd: Y<=4'h4;
			4'he: Y<=4'h4;
			4'hf: Y<=4'h0;
		default: Y<=4'h0;

	endcase
endmodule
