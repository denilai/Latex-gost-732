`timescale 1ns / 1ps
module top(
    input CLK,
    input CPU_RSTn,
    input BTN_C,
    input  [3:0] SW,
    output [7:0] CAT,
    output [7:0] AN
    );

    reg rst;
    
    always @(posedge CLK) begin 
        rst <= ~CPU_RSTn; 
    end
    wire [31:0] hex;
    wire [7:0] disp_en;
    
    NexysDisplay Disp(
        .CLK(CLK),
        .RST(rst),
        .HEX_IN(hex),
        .DISP_EN(disp_en),
        .CA(CAT[0]),
        .CB(CAT[1]),
        .CC(CAT[2]),
        .CD(CAT[3]),
        .CE(CAT[4]),
        .CF(CAT[5]),
        .CG(CAT[6]),
        .DP(CAT[7]),
        .AN(AN)
    );
    wire divClk;
    freq_div DIV( 
    .rst(rst), 
    .clk(CLK), 
    .co(divClk) 
    );
    wire loadDebounced;
	wire loadDebounced1;
	  M_BTN_FILTER_V10 Filter(
	 .CLK(CLK),
    .CE(divClk),
    .BTN_IN(BTN_C),
    .RST(rst),
    .BTN_OUT(),
    .BTN_CEO(loadDebounced)
    );
    seqAuto Auto(
    .clk(CLK),
    .rst(rst),
    .load(loadDebounced),
    .data(SW),
    .display(hex),
    .displayEnable(disp_en)
    );
endmodule
