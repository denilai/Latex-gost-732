`timescale 1ns / 1ps

module seqAuto(
	input clk,
	input rst,
	input load,
	input [3:0] data,
	output reg [31:0] display,
	output reg [7:0] displayEnable
	);


	reg [3:0] state;
	reg updateDisplay;

	wire[3:0] expected;

	outFunc CL(
	  .in(state),
	  .out(expected)
	);


	always @(posedge clk, posedge rst) 
		begin
			if (rst) 
				begin
					state <= 0;
					display <= 0;
					displayEnable <= 0;
					updateDisplay <= 1;
				end
			else
				begin
					if (updateDisplay)
						begin
							// If we are in the first state in the four
							if (state[1:0] == 2'b00)
								begin
									// display only the left digit on the left display
									displayEnable[7:4] <= 4'h1;
									// we output the corresponding value of the function to this place
									display[19:16] <= expected;
									// we output zeros to the remaining 3 digits of the left display
									display[31:20] <= 0;
								end 
							else 
								begin
								// shift the digits on the left display by 1 digit
									displayEnable[7:4] <= {displayEnable[6:4], 1'b1};
									display[31:16] <= {display[27:16], expected};
								end
								updateDisplay <= 0;
						end
					// if the download signal is given
					if (load)
						begin
							// we shift the digits on the right dipley by 1 digit
							displayEnable[3:0] <= {displayEnable[2:0], 1'b1};
							display[15:0 ]<= {display[11:0], data};
							// if the correct digit is entered
							if (data == expected)
								begin
								// go to the next state
									state <= state + 1'b1;
								end
							else
								// going back to a multiple of the 4th
								begin
									state <= state & 4'b1100;
								end
							updateDisplay <= 1;
						end
				end       
		end
endmodule
