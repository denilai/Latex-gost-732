`timescale 1ns / 1ps

module top(
	input         CLK,
	input         SYS_NRST,
	input         LEFT,
	input         RIGHT,
	
	output [7:0]  rows,
	output [7:0]  cols
	);	
    reg        RST = 0;
	wire [3:0] seq;
	wire       CE_1MHZ;
	
	always@(posedge  CLK)
	   RST = SYS_NRST;

	reg [63:0] func;
	wire [63:0] shift_func	;
	wire [15:0] pwm_p;
	
	reg [15:0] pwm_n;
	
	initial func<=64'hca25c7d227038440;
	 
	// Divider 1MHz:
	M_CLOCK_DIVIDER #(
	.DIVIDER(20),
	.CNT_WDT(6)
	) DIV_1KHZ (
	.CLK(CLK),
	.RST(RST),
	.CEO(CE_1MHZ));
	
	M_BTN_FILTER_V10 FLTR_STEP(.BTN_IN(LEFT),.CLK(CLK)
							   ,.CE(CE_1MHZ),.RST(RST),.BTN_CEO(BTN_LEFT));
	M_BTN_FILTER_V10 FLTR_UP(.BTN_IN(RIGHT),.CLK(CLK)
							 ,.CE(CE_1MHZ),.RST(RST),.BTN_OUT(BTN_RIGHT));
	
	SR64_S4B shifter (
							.data_in(func),
							.RST(RST),
							.CLK(CLK),
							.shift_4b_l(LEFT),
							.shift_4b_r(RIGHT),
							.data_out(shift_func)
	);
	genvar i;
	generate
		for (i=0;i<16;i=i+1) begin
			PWM_module pwm_i(
						.CLK(CLK),
						.RST(SYS_NRST),
						.CE(CE_1MHZ),
						.pwm_in(shift_func[4*(i+1)-1:4*i]),
						.pwm_p(pwm_p[i])
						);			
			end
	endgenerate
	LCDMatrixDriverNew lcd(.data(shift_func), .RST(RST), .CE(CE_1MHZ)
						   , .CLK(CLK), .col_select(cols), .rows(rows));
    

endmodule
