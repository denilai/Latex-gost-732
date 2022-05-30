`timescale 1ns / 1ps

module test_fsm;
 
	// Inputs
	reg 		 rst;
	reg 		 clk;
	reg 		 ce;
	reg 		 load;
	reg 		 up;
	reg [3:0] data;

	// Outputs
	wire [3:0] seq;

	// Instantiate the Unit Under Test (UUT)
	fsm uut (
		.rst(rst), 
		.clk(clk), 
		.ce(ce), 
		.load(load), 
		.up(up),  
		.data(data), 
		.seq(seq)
	);
	always 
		#5 clk=~clk;

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
		ce = 0;
		load = 0;
		up = 0;
		data = 0; 

		// Wait 100 ns for global reset to finish
		#100;
		 
		// count forward
		
		rst=0; 
		ce=1;
		up=1;
		#165;
		
		//count bashward
		 
		rst=0;
		ce=1;
		up=0;
		#180;
		
		//one state (store mode)
		
		rst=0;
		ce=0;
		up=0;
		#100;
		
		 
		rst=0; 
		ce=0;
		up=0;
		load=1;
		
		//load mode
		data=4'h0; 
		#20;
		data=4'h1; 
		#20;
		data=4'h2; 
		#20;
		data=4'h3;
		#20; 
		data=4'h4;
		#20;
		data=4'h5;
		#20;
		data=4'h6; 
		#20;
		data=4'h7;
		#20; 
		data=4'h8;
		#20;
		data=4'h9;
		#20;
		data=4'ha; 
		#20;
		data=4'hb;
		#20; 
		data=4'hc;
		#20;
		data=4'hd;
		#20;
		data=4'he; 
		#20; 
		data=4'hf;
		//#20;
		
		$stop;

		// Add stimulus here

	end
endmodule

