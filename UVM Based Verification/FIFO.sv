////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module fifo(fifo_if.DUT fifoif);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic clk;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

// assigning signals to be interfaced
// inputs
assign clk = fifoif.clk;
assign data_in = fifoif.data_in;
assign rst_n = fifoif.rst_n;
assign wr_en = fifoif.wr_en;
assign rd_en = fifoif.rd_en;
// outputs
assign fifoif.data_out = data_out;
assign fifoif.wr_ack = wr_ack;
assign fifoif.overflow = overflow;
assign fifoif.full = full;
assign fifoif.empty = empty;
assign fifoif.almostfull = almostfull;
assign fifoif.almostempty = almostempty;
assign fifoif.underflow = underflow;



localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0; // was added
		overflow <= 0; // was added
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0; // was added
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow <= 0; // was added
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0; // was added
	end
	else begin
		if(empty && rd_en) // this is sequential output not combinational
			underflow = 1;
		else 
			underflow = 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if (wr_en && rd_en && empty) // this condition was added 
			count <= count + 1;
		else if (wr_en && rd_en && full) // this condition was added 
			count <= count - 1; 
		else if ( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;  
assign empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; // this was synchronized 
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

endmodule