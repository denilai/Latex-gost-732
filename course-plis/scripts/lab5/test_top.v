`timescale 1ns / 1ps

module test_top;

	// Clock Generator - 48 MHz
	parameter PERIOD_CLK = 20.8; // 20.8ns
	parameter DUTY_CYCLE_CLK = 0.4;
	
	reg        CLK, SYS_NRST;
	reg        LEFT;
	reg        RIGHT;
	wire [7:0] rows;
	wire [7:0] cols;

	initial
	forever
		begin
			CLK = 1'b0;
			#(PERIOD_CLK-(PERIOD_CLK*DUTY_CYCLE_CLK)) CLK = 1'b1;
			#(PERIOD_CLK*DUTY_CYCLE_CLK);
		end

	// Init. Reset startRIGHT pulse (100ns POR)
	initial
	begin
		SYS_NRST = 0;
		#100;
		SYS_NRST = 1;
		#100;
		SYS_NRST = 0;
	end
    top utt(
				.CLK(CLK)
			  ,.SYS_NRST(SYS_NRST)
			  ,.LEFT(LEFT)
			  ,.RIGHT(RIGHT)
			  ,.rows(rows)
			  ,.cols(cols)
		  
		  );
		assign COL_7R=cols[7];
		initial begin
		// Initialize Inputs
		LEFT = 0;
	   RIGHT   = 0;
		// Wait 100 ns for global reset to finish
		#100;
		 
		@(posedge COL_7R);
		@(posedge CLK);
		#(PERIOD_CLK*0.2);
		LEFT = 1'b1;
		#(PERIOD_CLK);
		LEFT = 1'b0;
		@(posedge COL_7R);
		@(posedge CLK);
		#(PERIOD_CLK*0.2);
		LEFT = 1'b1;
		#(PERIOD_CLK);
		LEFT = 1'b0;
 
        // --- input signals


		
    end
endmodule