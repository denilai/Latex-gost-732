module freq_div(input       rst, 
                input       clk, 
			    output reg  co);
	                   reg [16:0] counter;
	 parameter divisior = 17'd4;
	 
	 initial begin
	 co=0;
	 counter=0;
	 end
	 
	 always @(posedge clk or posedge rst) begin
		if (rst)
			begin
				counter <= 0;
				co <= 0;
			end
		else
				if (counter >= (divisior - 17'b1))
					begin
						counter <= 17'b0;
						co <= 1;
					end 
				else
				begin
					co <= 0;
					counter <= counter + 17'b1;
				end
	end
endmodule

