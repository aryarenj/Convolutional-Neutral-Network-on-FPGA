`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:38:06 05/08/2018 
// Design Name: 
// Module Name:    maxpool 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module maxpool(
	input [4:0] stride,
	input  maxpool_enable, 
	output reg [18:0] address1 , write_address,
	output reg maxpool_done, patch_end,
	input clk ,
	input reset,
	input [9:0]  w1 ,h1,
	input [4:0] w2,h2,
	output reg [9:0] width, height
    );

reg  last_col;
reg [9:0]  mod1;
reg [18:0] v;
reg [4:0] h_count , v_count;
reg [5:0] kkk;
reg [5:0] h_box_count , v_box_count;

initial begin	
    maxpool_done = 0;
    h_count = 4'b0;
    v = 19'b0;
    v_count = 4'b0;
    h_box_count = 6'b0;
    v_box_count = 6'b0;
	 write_address = 19'b0;
	 address1 = 19'b0;
	 width = 0;
	 height =0;
end


///// 	if (convolved_input[k] > max) 	max <= convolved_input[k];
	
	
	
	

always @(posedge clk)	begin		
	
	if (maxpool_enable) begin
		
		patch_end = 0;
		kkk = w1/w2;
		if (h_box_count == kkk	)	 last_col =1;	//31		
		
		if (last_col) begin	       
			mod1 = (address1 ) % w1;        //314
			if (mod1 == (w1-1) ) begin     //313
				//width =(!h_count) ? width: h_count;
				h_count = 5'b00000;
				v = v + w1;	      //314
				v_count = v_count + 1;
			end else 	h_count = h_count + 1;
			if (v_count == h2) begin        //11
				h_box_count = 6'b000000;
				v_box_count = v_box_count + 1;
				h_count = 5'b00000;
				v = w1 * stride * v_box_count;
				patch_end = 1;
				v_count = 5'b00000;
				last_col =0 ;
			end		
		end 	
		else begin 
			
			h_count = h_count + 1;
			if (h_count == w2) begin
				h_count = 5'b00000;
				v = v + w1;       //314
				v_count = v_count + 1;
			end
			if (v_count == h2) begin
				h_box_count = h_box_count + 1;
				v_count = 5'b00000;
				h_count = 5'b00000;
				v = (v_box_count * w1  + h_box_count) * stride;
				patch_end = 1;		// patch is over
			end
		end
		
		address1 = v + h_count   ;     //v from 0 to 129053	
		if (address1 == h1*w1 ) maxpool_done = 1;		//end of maxpool
		
		if (patch_end)	write_address	= write_address + 1;
	
	end
		
end
	


endmodule
