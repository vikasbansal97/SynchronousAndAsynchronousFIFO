module async_fifo (wclk,rclk,wreq,rreq,rst_n,wdata,full,empty,rdata);
 parameter DSIZE = 8;//Data size
 parameter ASIZE = 4;//Address bit 16 address
 
 input wclk;
 input rclk;
 input rst_n;
 input wreq;
 input rreq;
 input [DSIZE-1:0] wdata;
 output reg [DSIZE-1:0] rdata;
 output reg full;
 output reg empty;
  reg [ASIZE:0] wq2_rptr, wq1_rptr, rptr;
 reg [ASIZE:0] rq2_wptr, rq1_wptr, wptr;
 wire rempty_val;
 wire [ASIZE : 0] rptr_nxt;
 wire [ASIZE-1:0] raddr;// read address
 reg [ASIZE:0] rbin;//
 wire [ASIZE:0] rbin_nxt;
 wire [ASIZE-1:0] waddr;//write address
 reg [ASIZE:0] wbin;
 wire [ASIZE:0] wbin_nxt;
 wire [ASIZE : 0] wptr_nxt;
 
 // synchronizing rptr to wclk
 always @(posedge wclk or negedge rst_n) begin
 if(!rst_n) {wq2_rptr, wq1_rptr} <= 2'b0;
 else {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
 end
 
 // synchronizing wptr to rclk
 always @(posedge rclk or negedge rst_n) begin
 if(!rst_n) {rq2_wptr, rq1_wptr} <= 2'b0;
 else {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
 end
 
 // generating rempty condition
 //reg rempty;
 assign rempty_val = (rptr_nxt == rq2_wptr); 
always @(posedge rclk or negedge rst_n) begin
 if(!rst_n) empty <= 1'b0;
 else empty <= rempty_val;
end
 
 // generating read address for fifomem
 assign rbin_nxt = rbin + (rreq & ~empty);
 
 always @ (posedge rclk or negedge rst_n) 
 if (!rst_n)rbin <= 0;
 else rbin <= rbin_nxt;
 assign raddr = rbin[ASIZE-1:0]; 
 
 // generating rptr to send to wclk domain
 // convert from binary to gray
 assign rptr_nxt = rbin_nxt ^ (rbin_nxt>>1);
 
 always @ (posedge rclk or negedge rst_n)
 if (!rst_n) rptr <= 0;
 else rptr <= rptr_nxt;
 
 // generating write address for fifomem
 assign wbin_nxt = wbin + (wreq & !full);
 
 always @ (posedge wclk or negedge rst_n)
 if(!rst_n) wbin <= 0;
 else wbin <= wbin_nxt;
 
 assign waddr = wbin [ASIZE-1:0];
 
 // generating wptr to send to rclk domain
 // convert from binary to gray
 
 assign wptr_nxt = (wbin_nxt>>1) ^ wbin_nxt; 
 
 always @ (posedge wclk or negedge rst_n)
 if(!rst_n) wptr <= 0;
 else wptr <= wptr_nxt;
 
 // generate wfull condition
 wire wfull_val;
 assign wfull_val = (wq2_rptr == {~wptr[ASIZE : ASIZE-1],wptr[ASIZE-2 : 0]});
 
 always @ (posedge wclk or negedge rst_n)
 if (!rst_n) full <= 0;
 else full <= wfull_val;
 
 // fifomem
 // Using Verilog memory model
 localparam DEPTH = (1 << (ASIZE));
 reg [DSIZE-1 : 0] mem [0: DEPTH -1];
 always @ (posedge wclk) if (wreq & !full) mem[waddr] <= wdata;
 always @ (posedge rclk) if (rreq & !empty) rdata<=mem[raddr];
endmodule