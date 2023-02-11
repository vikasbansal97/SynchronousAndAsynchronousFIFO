module sync_fifo(data_out,full,empty,data_in,clk,rst_a,wr_en,rd_en);
    parameter data_width = 4;
    parameter address_width = 4;
    parameter ram_depth =16;

    input [data_width-1:0] data_in;
    input clk;
    input rst_a;
    input wr_en;
    input rd_en;

    output [data_width-1:0] data_out;
    output full;
    output empty;
    
    reg [address_width-1:0] wr_pointer;
    reg [address_width-1:0] rd_pointer;
    reg [address_width :0] status_count;
    reg [data_width-1:0] data_out ;
    wire [data_width-1:0] data_ram ;

    always @ (posedge clk,posedge rst_a) begin
        if(rst_a)
            wr_pointer = 0;
        else
        if(wr_en&&full==0)
            wr_pointer = wr_pointer+1;
    end

    always @ (negedge clk,posedge rst_a) begin
    if(rst_a)
        rd_pointer = 0;
    else
        if(rd_en&&empty==0)
        rd_pointer = rd_pointer+1;
    end

    always @ (negedge clk,posedge rst_a)begin
        if(rst_a)
            data_out=0;
        else
            if(rd_en&&empty==0)
                data_out=data_ram;
    end

    always @ (posedge clk,posedge rst_a) begin
        if(rst_a)
            status_count = 0;
        else
            if(wr_en && !rd_en && (status_count != (ram_depth-1)))
                status_count = status_count + 1;
    end

    always @ (negedge clk,posedge rst_a) begin
        if(rst_a)
            status_count = 0;
        else
            if(rd_en && !wr_en && (status_count != 0))
                status_count = status_count - 1;
    end // always @ (posedge clk,posedge rst_a)
    
    assign full = (status_count == (ram_depth-1));
    assign empty = (status_count == 0);
    memory_16x4 u1(.address_1(wr_pointer),.address_2(rd_pointer),.data_1(data_in),.data_2(data_ram),.wr_en1(wr_en),.rd_en2(rd_en),.clk(clk));
endmodule

module memory_16x4(data_1,data_2,wr_en1,rd_en2,clk,address_1,address_2);
 parameter data_width = 4;
 parameter address_width = 4;
 parameter ram_depth =16;
 
 input [data_width-1:0] data_1;
 output [data_width-1:0] data_2;
 input [address_width-1:0] address_1;
 input [address_width-1:0] address_2;
 input wr_en1,clk,rd_en2;
 
 reg [address_width-1:0] memory[0:ram_depth-1];
 reg [data_width-1:0] data_2_out;
 wire [data_width-1:0] data_2;
 
 always @(posedge clk)
 begin
 if (wr_en1)
 memory[address_1]=data_1;
 end
 always @(posedge clk)
 begin
 if (rd_en2)
 data_2_out=memory[address_2];
 end
 assign data_2=(rd_en2)?data_2_out:4'b0000;
endmodule