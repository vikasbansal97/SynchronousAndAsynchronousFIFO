`timescale 1ns/1ns
`include "async_fifo.v"

module async_fifo_tb;
 
 parameter DSIZE = 8;
 parameter ASIZE = 4;
 parameter WCLK_PERIOD = 10;
 parameter RCLK_PERIOD = 30;
 
 reg wreq, wclk, rst_n, rreq, rclk;
 reg [DSIZE-1:0] wdata;
 wire [DSIZE-1:0] rdata;
 wire full, empty;
 integer i;
// Instance
async_fifo //parameter override
#( 
 .DSIZE(DSIZE),
 .ASIZE(ASIZE)
)
u_async_fifo
(
 .wreq (wreq),.wclk(wclk),
 .rreq(rreq), .rclk(rclk), .rst_n(rst_n),
 .wdata(wdata), .rdata(rdata), .full(full), .empty(empty)
);
 always #(RCLK_PERIOD/2)rclk=!rclk;
 always # (WCLK_PERIOD/2)wclk=!wclk;
initial begin
 wclk = 0;
 wreq = 0;
 wdata = 0;
 rst_n=0;
 rclk=0;
 rreq=0;
end
 
initial 
 begin
 $dumpfile("async_fifo_tb.vcd"); 
 $dumpvars(0,async_fifo_tb);
end 
task wr_task;
 begin 
 repeat (16) begin
 @(negedge wclk); wreq = 1;wdata = wdata+1;rreq=0;
 end 
 end
endtask
 
 task rd_task;
 begin 
 i=0;
 repeat (16) begin
 @(negedge rclk); rreq = 1;wreq=0;
 @(posedge rclk);#1;
 i=i+1;
 if (rdata==i) $display ("design is correct");
 else $display ("design is wrong");
 end 
 end
endtask
initial begin
 #50;
 rst_n=1;
 wr_task;
 rd_task;
 #100;
 $finish;
end
endmodule