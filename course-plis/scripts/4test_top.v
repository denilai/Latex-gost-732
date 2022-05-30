`timescale 1ns / 1ps

module test_top;

	// Clock Generator - 48 MHz
	parameter PERIOD_CLK = 20.8; // 20.8ns
	parameter DUTY_CYCLE_CLK = 0.4;
	
	reg        CLK, SYS_NRST;
	reg        STEP;
	reg        UP;
	wire [7:0] rows;
	wire [7:0] cols;

	initial
	forever
		begin
			CLK = 1'b0;
			#(PERIOD_CLK-(PERIOD_CLK*DUTY_CYCLE_CLK)) CLK = 1'b1;
			#(PERIOD_CLK*DUTY_CYCLE_CLK);
		end

	// Init. Reset startUP pulse (100ns POR)
	initial
	begin
		SYS_NRST = 0;
		#100;
		SYS_NRST = 1;
		#100;
		SYS_NRST = 0;
	end
	
    top utt(
        .CLK(CLK),
        .SYS_NRST(SYS_NRST),
        .STEP(STEP),
        .UP(UP),
        .rows(rows),
        .cols(cols)
		  );
		  
		  
		assign COL_7R=cols[7];


		initial begin
		// Initialize Inputs
		STEP = 0;
	   UP   = 1;
		// Wait 100 ns for global reset to finish
		#100;

		 
		@(posedge COL_7R);
		@(posedge CLK);
		#(PERIOD_CLK*0.2);
		STEP = 1'b1;
		#(PERIOD_CLK);
		STEP = 1'b0;


    // ..... 
    // input sequece

		@(posedge COL_7R);
		@(posedge CLK);
		#(PERIOD_CLK*0.2);
		STEP = 1'b1;
		#(PERIOD_CLK);
		STEP = 1'b0;
        
    end
endmodule
