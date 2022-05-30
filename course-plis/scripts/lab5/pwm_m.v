`timescale 1ns / 1ps
module PWM_module #(parameter UDW = 4)
    (
    input CLK,
    input RST,
    input CE,
    input [UDW - 1:0] pwm_in,
    output reg pwm_p,
	 output reg [UDW - 1:0] pwm_reg, fsm_state
    );
    
    assign pwm_n = ~pwm_p;
        
    initial
    begin
        pwm_reg <= 0;
        fsm_state <= 0;
        pwm_p <= 0;
    end
	 
    
    always@(posedge CLK, posedge RST)
    begin
        if(RST)
        begin
            pwm_reg <= 0;
        end
        else if(CE && fsm_state == {{(UDW - 1){1'b1}}, {1'b0}})
        begin
            pwm_reg <= pwm_in;
        end
    end
    
    always@(posedge CLK, posedge RST)
    begin
        if(RST)
        begin
            pwm_reg <= 0;
            fsm_state <= 0;
            pwm_p <= 0;
        end
        else if (CE)
        begin
            case(fsm_state)
                0:
                begin
                    fsm_state <= {{(UDW - 1){1'b1}}, {1'b0}};
                    pwm_p <= 0;
                end
                {(UDW){1'b1}}:
                begin
                    fsm_state <= 1;
                    pwm_p <= pwm_reg == {(UDW){1'b0}} ? 0 : 1;
                end        
                default:
                begin
                    fsm_state <= fsm_state + 1;
                    pwm_p <= pwm_reg > fsm_state ? 1 : 0;
                end
            endcase
        end
        else
        begin
            fsm_state <= fsm_state;
        end
    end
endmodule
