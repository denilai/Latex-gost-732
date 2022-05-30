`timescale 1ns / 1ps

module SR64_S4B(
	 input [63:0] data_in,
	 input RST,
    input CLK,
    input shift_4b_l,
    input shift_4b_r,
    output reg [63:0] data_out
    );

    
    always@(posedge CLK, posedge RST)
    begin
		if (RST)
			begin
				data_out <=data_in;
			end
		else
		begin
			if(shift_4b_l) 
			begin
				data_out <= {data_out[59:0], data_out[63:60]};
			end
			else if (shift_4b_r)
			begin
				data_out <= {data_out[3:0], data_out[63:4]};
			end
			else
			begin
				data_out <= data_out;
			end
		end
    end
endmodule
