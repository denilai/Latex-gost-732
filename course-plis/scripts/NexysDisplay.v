`timescale 1ns / 1ps

module NexysDisplay(
input CLK,
input RST,
input [31:0] HEX_IN,
input [7:0] DISP_EN,
output CA,
output CB,
output CC,
output CD,
output CE,
output CF,
output CG,
output DP,
output [7:0] AN
);
// Internal signals declaration:
//------------------------------------------
reg [9:0] CLK_DIV_H, CLK_DIV_L;
reg CEO_DIV_H, CEO_DIV_L;
reg [2:0] DIGIT_CNT;
reg [3:0] I_CODE;
wire O_SEG_A, O_SEG_B, O_SEG_C, O_SEG_D, O_SEG_E, O_SEG_F, O_SEG_G;
reg [7:0] ANODE_DC;
//------------------------------------------
// 1048576 Clock Divider:
always @ (posedge CLK, posedge RST)
if(RST)
	begin
		CLK_DIV_H <= 10'h000;
		CLK_DIV_L <= 10'h000;
		CEO_DIV_H <= 1'b0;
		CEO_DIV_L <= 1'b0;
	end
else
	begin
		if(CLK_DIV_H == 10'h063) // 3FF - :1024 , 063 - :100
			begin
				CLK_DIV_H <= 10'h000;
				CEO_DIV_H <= 1'b1;
			end
		else
			begin
				CLK_DIV_H <= CLK_DIV_H + 1;
				CEO_DIV_H <= 1'b0;
			end
		if(CEO_DIV_H)
			begin
				if(&(CLK_DIV_L))
					CLK_DIV_L <= 10'h000;
				else
					CLK_DIV_L <= CLK_DIV_L + 1;
			end
		if(&(CLK_DIV_L) & CEO_DIV_H)
			CEO_DIV_L <= 1'b1;
		else
			CEO_DIV_L <= 1'b0;
	end
//------------------------------------------
// Display Digit Counter:
always @ (posedge CLK, posedge RST)
if(RST) DIGIT_CNT <= 3'd0;
else if(CEO_DIV_L) DIGIT_CNT <= DIGIT_CNT + 1;
//------------------------------------------
// Display Digit Multiplexer:
always @ (DIGIT_CNT, HEX_IN, DISP_EN)
case(DIGIT_CNT)
3'd0:
begin
I_CODE <= HEX_IN[3:0];
ANODE_DC <= DISP_EN[0] ? 8'd1 : 0;
end
3'd1:
begin
I_CODE <= HEX_IN[7:4];
ANODE_DC <= DISP_EN[1] ? 8'd2 : 0;
end
3'd2:
begin
I_CODE <= HEX_IN[11:8];
ANODE_DC <= DISP_EN[2] ? 8'd4 : 0;
end
3'd3:
begin
I_CODE <= HEX_IN[15:12];
ANODE_DC <= DISP_EN[3] ? 8'd8 : 0;
end
3'd4:
begin
I_CODE <= HEX_IN[19:16];
ANODE_DC <= DISP_EN[4] ? 8'd16 : 0;
end
3'd5:
begin
I_CODE <= HEX_IN[23:20];
ANODE_DC <= DISP_EN[5] ? 8'd32 : 0;
end
3'd6:
begin
I_CODE <= HEX_IN[27:24];
ANODE_DC <= DISP_EN[6] ? 8'd64 : 0;
end
default:
begin
I_CODE <= HEX_IN[31:28];
ANODE_DC <= DISP_EN[7] ? 8'd128 : 0;
end
endcase
//------------------------------------------
// 7-Segment Decoder:
SevenSegDec DISP_DEC (
.I_CODE(I_CODE), 
.O_SEG_A(O_SEG_A), 
.O_SEG_B(O_SEG_B), 
.O_SEG_C(O_SEG_C),
.O_SEG_D(O_SEG_D), 
.O_SEG_E(O_SEG_E), 
.O_SEG_F(O_SEG_F),
.O_SEG_G(O_SEG_G));
//------------------------------------------
assign AN = ~ANODE_DC | {8{RST}};
assign CA = ~O_SEG_A;
assign CB = ~O_SEG_B;
assign CC = ~O_SEG_C;
assign CD = ~O_SEG_D;
assign CE = ~O_SEG_E;
assign CF = ~O_SEG_F;
assign CG = ~O_SEG_G;
assign DP = 0;
//------------------------------------------
endmodule
