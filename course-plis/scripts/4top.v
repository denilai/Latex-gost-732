`timescale 1ns / 1ps

module top(
	input         CLK,
	input         SYS_NRST,
	input         STEP,
	input         UP,
	
	output [7:0]  rows,
	output [7:0]  cols
	
	);	
	
  reg        RST = 0;
	wire [3:0] seq;
	wire       CE_1MHZ;
	
	always@(posedge  CLK)
	   RST = SYS_NRST;
		
	// Divider 1MHz:
	M_CLOCK_DIVIDER #(
	.DIVIDER(48),
	.CNT_WDT(6)
	) DIV_1MHZ (
	.CLK(CLK),
	.RST(RST),
	.CEO(CE_1MHZ));
	
	wire BTN_STEP, BTN_UP;
	// Filtered input signals
	M_BTN_FILTER_V10 FLTR_STEP(.BTN_IN(STEP),.CLK(CLK)
	,.CE(CE_1MHZ),.RST(RST),.BTN_CEO(BTN_STEP));
	M_BTN_FILTER_V10 FLTR_UP(.BTN_IN(UP),.CLK(CLK)
	,.CE(CE_1MHZ),.RST(RST),.BTN_OUT(BTN_UP));
	
	// FSM sequence generator
	LR2_SEQ_GEN_FSM fsm(.RST(RST), .CLK(CLK), .CE(STEP), .load(0), .up(UP), .data(0), .seq(seq));

	LR4_MATRIX_DISP_V10 lcd(.data(seq), .CE(CE_1MHZ), .CLK(CLK), .col_select(cols), .rows(rows), .RST(RST));

endmodule
