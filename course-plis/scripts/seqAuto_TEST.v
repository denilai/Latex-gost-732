`timescale 1ns / 1ps

module seqAuto_TEST;
	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg [3:0] data;

	// Outputs
	wire [31:0] display;
	wire [7:0] displayEnable;

	seqAuto uut(
        .clk(clk),
        .rst(rst),
        .load(load),
        .data(data),
        .display(display),
        .displayEnable(displayEnable)
    );
	
	always #10 clk=~clk;
	
	reg [3:0] sequence [0:15];
	
	reg [3:0] seqCount;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		load = 0;
		data = 0;
		seqCount = 0;
		sequence[0] = 4'hc;   
		sequence[1] = 4'ha;   
		sequence[2] = 4'h2;
		sequence[3] = 4'h5;
		sequence[4] = 4'hc;
		sequence[5] = 4'h7;
		sequence[6] = 4'hd;
		sequence[7] = 4'h2;
		sequence[8] = 4'h2;
		sequence[9] = 4'h7;
		sequence[10] = 4'h0;
		sequence[11] = 4'h3;
		sequence[12] = 4'h8;
		sequence[13] = 4'h4;
		sequence[14] = 4'h4;
		sequence[15] = 4'h0;
		#20
		rst = 0;
		#20
		
		while (seqCount != 4'h3) begin
		  data = seqCount;
		  load = 1;
		  #20;
		  seqCount = seqCount + 1'b1;
		  load = 0;
		  #20;
		end
		#20
		seqCount = 0;
		#20
		while (seqCount != 4'h8) begin
		  data = sequence[seqCount];
		  load = 1;
		  #20;
		  seqCount = seqCount + 1'b1;
		  load = 0;
		  #20;
		end
		data = sequence[seqCount];
		load = 1;
		#20
		load = 0;
		#20
		while (seqCount != 4'hc) begin
		  data = seqCount;
		  load = 1;
		  #20;
		  seqCount = seqCount + 1'b1;
		  load = 0;
		  #20;
		end
		#20
		seqCount = 4'h8;
		#20
		while (seqCount != 4'hf) begin
		  data = sequence[seqCount];
		  load = 1;
		  #20;
		  seqCount = seqCount + 1'b1;
		  load = 0;
		  #20;
		end
		data = sequence[seqCount];
		load = 1;
		#20
		load = 0;
		#20
		$stop;
	end
	
endmodule
