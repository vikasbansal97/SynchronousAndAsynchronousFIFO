`timescale 1ns/1ns
`include "sync_fifo.v"

module sync_fifo_tb;
// Inputs
reg [3:0] data_in;
reg clk;
reg rst_a;
reg wr_en;
reg rd_en;

// Outputs
wire [3:0] data_out;
wire full;
wire empty;
// Instantiate the Unit Under Test (UUT)
sync_fifo uut (
.data_out(data_out), 
.full(full), 
.empty(empty), 
.data_in(data_in), 
.clk(clk), 
.rst_a(rst_a), 
.wr_en(wr_en), 
.rd_en(rd_en)
);
initial begin
clk=1'b1;
forever #5 clk=~clk;
end
initial begin
 rst_a=1'b1;
 data_in=4'b0000;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0001;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0010;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0011;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0100;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0101;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0110;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0111;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 data_in=4'b1000;
 #10;
 data_in=4'b1001;
 #10;
 data_in=4'b1010;
 #10;
 data_in=4'b1011;
 #10;
 data_in=4'b1100;
 #100;
 data_in=4'b1101;
 #10;
 data_in=4'b1110;
 #10;
 data_in=4'b1111;
 #10;
 rd_en=1'b1;
 wr_en=1'b0;
 #10;
 
 rst_a=1'b1;
 data_in=4'b0101;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0101;
 wr_en=1'b1;
 rd_en=1'b0;
 #10;
 rst_a=1'b0;
 data_in=4'b0110;
 wr_en=1'b0;
 rd_en=1'b1;
 #10; 
end
endmodule