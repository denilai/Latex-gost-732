`timescale 1ns / 1ps

module top(
	input          clk,
	input  [4:0]   SW,
	input          CPU_RESET,
	input          BTNC,
	input          BTNU,
	output [3:0]   LED
    );
	 
	 
	 reg            RST_I; 
	 wire           RST;
	 wire           CO;
	 wire           BTNC_CEO;
	 wire           BTNU_CEO;
	 
	 always @ (posedge clk, negedge CPU_RESET)
	   begin
		  if(~CPU_RESET)
		    RST_I <= 1'b1;
	     else
		    RST_I <= 1'b0;
		end
	 assign RST=RST_I;
	 freq_div #(10000) FREQ_CO (
	 .rst (RST),
	 .clk (clk),
	 .co  (CO)
	 );
	 
	 M_BTN_FILTER_V10 b_f_u(
	 .CLK     (clk),
    .CE      (CO),
    .BTN_IN  (BTNU),
    .RST     (RST_I),
	 .BTN_CEO (BTNU_CEO)
	 );
	 
	 M_BTN_FILTER_V10 b_f_c(
	 .CLK     (clk),
    .CE      (co),
    .BTN_IN  (BTNC),
    .RST     (RST_I),
	 .BTN_CEO (BTNC_CEO)
	 );
	 
	 
	 fsm FSM1(
	 .rst   (RST_I),
	 .clk   (clk),
    .ce    (BTNC_CEO),
    .load  (BTNU_CEO),
    .up    (SW[4]),
    .data  (SW[3:0]),  
	 .seq   (LED)
	 );
endmodule
