`timescale 1ns / 1ps

module LR4_MATRIX_DISP_V10(
  input      [3:0] data,
  input            CLK,
  input            CE,
  input            RST,
  output reg [7:0] col_select,
  output reg [7:0] rows
 );
    
    reg [2:0] column_ctr;
    
    reg [3:0] digit;
    
    reg [7:0] mem [127:0];
    
    initial
    begin
        digit = 0;
        column_ctr = 0;
        col_select = 8'hFF;
        $readmemb("lcd_digits.mem", mem);
    end
    
    wire digit_reg_ceo;
    assign digit_reg_ceo = column_ctr == 7;
    
    always@*
    begin
        case(column_ctr)
            3'd0: col_select <= 8'b01111111;
            3'd1: col_select <= 8'b10111111;
            3'd2: col_select <= 8'b11011111;
            3'd3: col_select <= 8'b11101111;
            3'd4: col_select <= 8'b11110111;
            3'd5: col_select <= 8'b11111011;
            3'd6: col_select <= 8'b11111101;
            3'd7: col_select <= 8'b11111110;
        endcase
    end
    
    always@*
    begin
        rows = mem[{digit, column_ctr}];
    end
    
    always@(posedge CLK, posedge RST) 
    begin
		if (RST)
			begin
			  digit = 0;
			  column_ctr = 0;
			  col_select = 8'hFF;
		end
		else
			begin
			  if(CE)
			  begin
					column_ctr <= column_ctr + 1;
			  end
			  if(digit_reg_ceo)
			  begin
					digit <= data;
			  end
		  end
    end
endmodule
