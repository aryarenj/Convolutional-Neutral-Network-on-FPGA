`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:46 05/08/2018 
// Design Name: 
// Module Name:    maxpool_new 
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
module maxpool_new(
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



reg [9:0] H1_index_outer , V1_index_outer ;
reg [5:0]	v1_index_inner , h1_index_inner ;
reg patch_begin ;


initial begin
	H1_index_outer=0;
	V1_index_outer =0;
	v1_index_inner =0;
	h1_index_inner =0;
	address1 = 0; 
	
	write_address =0;
	
	patch_begin =1;
	patch_end = 0;
	maxpool_done = 0;
end


always @ (posedge clk) begin	// Output_logic
		if (maxpool_enable) begin
					
				if (patch_begin) begin
						v1_index_inner = 0;
						h1_index_inner = 0;
						patch_end = 0;
						patch_begin = 0;
				end	
					
				if (!maxpool_done) begin
					address1 = address1 + 2'b01;
					h1_index_inner = h1_index_inner + 2'b01 ;
					
					if (h1_index_inner == w2) begin			//end of patch horizontal
						v1_index_inner = v1_index_inner + 1;
						h1_index_inner = 6'b0;								
						address1 = (v1_index_inner + V1_index_outer )* w1 + H1_index_outer;
					end	

					if (v1_index_inner == h2) begin			//end of patch vertical
						H1_index_outer = H1_index_outer + stride;
						address1 = V1_index_outer * w1 + H1_index_outer ;
						patch_end = 1;
						patch_begin =1;
						v1_index_inner = 6'b0;
					end
																				
					if ((H1_index_outer + w2) > w1	) begin		//end of a full row
						width = H1_index_outer/w2;
						patch_begin = 1;
						V1_index_outer = V1_index_outer + stride;
						H1_index_outer = 10'b0000000000;
						address1 = V1_index_outer * w1;
					end
					if (address1 == h1*w1 ) 		maxpool_done = 1;		//end of full conv	
					if (maxpool_done)   height = V1_index_outer/h2 ;
					//if ((address1 + 1) == h1*w1 ) 		height = V1_index_outer + 1;
					
					if (patch_begin)	write_address	= write_address + 1;
					
				end
				
		
		end
    end
endmodule 