`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2018 01:50:12 PM
// Design Name: 
// Module Name: conv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv (
input [4:0] stride,
input  conv_enable, 
output reg [18:0] address1 , address2, write_address,
output reg end_reach, full_conv_end, dot_sum_end,
input clk,
input reset,
input [9:0] w1 ,h1,w2,h2,
output reg [9:0] width, height
  );


reg [9:0] H1_index_outer , V1_index_outer ;
reg [5:0]	v1_index_inner , h1_index_inner ;
reg dot_sum_start ;


initial begin
	H1_index_outer=0;
	V1_index_outer =0;
	v1_index_inner =0;
	h1_index_inner =0;
	address1 = 0; 
	address2 = 0;
	write_address =0;
	end_reach=0;
	dot_sum_end=0;
	dot_sum_start = 1;
	full_conv_end = 0;
end


always @ (posedge clk) begin	// Output_logic
		if (conv_enable) begin
					
				if (dot_sum_start) begin
						v1_index_inner = 0;
						h1_index_inner = 0;
						dot_sum_start = 0;
						dot_sum_end =0;
				end	
					
				if (!full_conv_end) begin
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
						dot_sum_start = 1;
						dot_sum_end =1;
						v1_index_inner = 6'b0;
					end
																				
					if ((H1_index_outer + w2) > w1	) begin		//end of a full row
						width = H1_index_outer;
						dot_sum_start = 1;
						V1_index_outer = V1_index_outer + stride;
						H1_index_outer = 10'b0000000000;
						address1 = V1_index_outer * w1;
					end
					if (address1 == h1*w1 ) 		full_conv_end = 1;		//end of full conv					
					if ((address1 + 1) == h1*w1 ) 		height = V1_index_outer + 1;
					
					address2 = v1_index_inner*w2 + h1_index_inner;
									
					if (dot_sum_start)	write_address	= write_address + 1;
					
				end
				
		
		end
    end
endmodule 