module afifo(wclk, wrstn, wren, wdata, wfull,rclk, rrstn, rden, rdata, rempty, rdready,wraddr,rdaddr);
	
parameter  dsize = 8,
           asize = 4;
localparam dw = dsize,
           aw = asize;
	
input     wire  wclk, wrstn, wren;
input     wire  [dw-1:0] wdata;
input	  wire  rclk, rrstn, rden;
	
output	  reg   wfull;
output	  reg	rempty;
output    wire  rdready;
output	  wire  [(dw*4)-1:0] rdata;
output    wire  [aw-1:0] wraddr,rdaddr;

           wire [aw-1:0] waddrmem, raddrmem;
	       wire [aw-1:0] waddrmem_mod4;
           wire          wfull_next, rempty_next;
	       reg  [aw:0]   wgray, wbin, wq2_rgray, wq1_rgray,rgray, rbin, rq2_wgray, rq1_wgray;
				
	
           wire [aw:0] wgraynext, wbinnext;
           wire [aw:0] rgraynext, rbinnext;

           reg [dw-1:0]	mem	[0:((1<<aw)-1)];

//sync-w-rgray part
initial	{ wq2_rgray,  wq1_rgray } = 0;
always @(posedge wclk or negedge wrstn)
 if (!wrstn)
   { wq2_rgray, wq1_rgray } <= 0;
else { wq2_rgray, wq1_rgray } <= { wq1_rgray, rgray };
	
assign	wbinnext  = wbin + { {(aw){1'b0}}, ((wren) && (!wfull)) };
assign	wgraynext = (wbinnext >> 1) ^ wbinnext;
assign	waddrmem = wbin[aw-1:0];


assign wraddr=waddrmem;
assign rdaddr=raddrmem;

// wadress part
initial	{ wbin, wgray } = 0;
always @(posedge wclk or negedge wrstn)
if (!wrstn)
	{ wbin, wgray } <= 0;
else
{ wbin, wgray } <= { wbinnext, wgraynext };

// comparison of low-order bits
assign	wfull_next = (wgraynext == { ~wq2_rgray[aw:aw-1],wq2_rgray[aw-2:0] });

				
initial	wfull = 0;
always @(posedge wclk or negedge wrstn)
 if (!wrstn)
    wfull <= 1'b0;
	else
	wfull <= wfull_next;

always @(posedge wclk)
	if ((wren)&&(!wfull))
		mem[waddrmem] <= wdata;
	
//sync-r-wgray part
initial	{ rq2_wgray,  rq1_wgray } = 0;
always @(posedge rclk or negedge rrstn)
if (!rrstn)
 { rq2_wgray, rq1_wgray } <= 0;
else
{ rq2_wgray, rq1_wgray } <= { rq1_wgray, wgray };

// increment read address
assign	rbinnext  = rbin + { {(aw-2){1'b0}}, ((rden)?3'b100:3'b000)};
assign	rgraynext = (rbinnext >> 1) ^ rbinnext;

initial	{ rbin, rgray } = 0;
	always @(posedge rclk or negedge rrstn)
if (!rrstn)
	{ rbin, rgray } <= 0;
else
	if (wbin <2'b11)
		rbin <=1'b0;
	else
	{ rbin, rgray } <= { rbinnext, rgraynext };

assign	raddrmem = rbin[aw-1:0];
assign	rempty_next = (rgraynext == rq2_wgray);
	
	
initial rempty = 1;
always @(posedge rclk or negedge rrstn)
if (!rrstn)
	rempty <= 1'b1;
else
	rempty <= rempty_next;
	
//every fourth address in memory
assign waddrmem_mod4=(waddrmem-1'b1) & {{(aw-3){1'b1}},{3'b100}};
assign rdready = (waddrmem>=3'b100||!rempty);
assign	rdata = rden&&rdready?{mem[raddrmem],mem[raddrmem+1'b1],
				mem[raddrmem+2'b10],mem[raddrmem+2'b11]}:{(dw*4){1'b1}};

endmodule
