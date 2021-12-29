module afifo_test();
parameter  dsize = 8,
           asize = 4;
localparam dw = dsize,
           aw = asize;
   integer fp_r,fp_w;  
   reg                wclk, wrstn, wren,clk_rst;
   reg [dw-1:0]       wdata;
   wire               wfull,rempty;
   reg                rclk, rrstn, rden;
   wire  [(dw*4)-1:0] rdata;
   wire               freq_clk;
   wire               rdready;
	wire [aw-1:0]     wraddr,rdaddr;

freq_div #(17'd4) fr_dv (
          .rst(clk_rst),
           .clk(wclk),
          .co(freq_clk)
                     );

afifo ff(
      .wclk(wclk),
      .wrstn(wrstn),
      .wren(wren),
      .wdata(wdata),
      .wfull(wfull),
      .rclk (freq_clk),
      .rrstn(rrstn),
      .rden(rden),
      .rdata(rdata),
      .rdready(rdready),
      .rempty(rempty),
      .wraddr(wraddr),
      .rdaddr(rdaddr)
      );


always
begin
   #5 wclk = ~wclk;
end
initial
begin
  wdata=2'h01;
  fp_r = $fopen ("data.txt", "r");
  fp_w = $fopen ("data_out.txt","a");
  clk_rst=0;
  wclk=0;
  wrstn=1;
  rrstn=1;
  wren=1;
  rden=0;

#195;
rden=1;

#155;
wrstn=0;
#10;
wrstn=1;
end
	
always@(posedge wclk)
begin
	$fscanf  (fp_r, "%h\n", wdata); // read one line
end

always@(posedge freq_clk)
if(rden)
	$fdisplay (fp_w, "%h", rdata); // write to file

endmodule
