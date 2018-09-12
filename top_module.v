`timescale 1ns / 1ps

`define OUTPUT_FILEPATH1   "./extracted_main.txt"
`define OUTPUT_FILEPATH2   "./extracted_pattern.txt"
`define OUTPUT_FILEPATH3   "./out_inter_conv.txt"
`define OUTPUT_FILEPATH4   "./out_inter_convHEX.txt"
`define OUTPUT_FILEPATH5   "./out_maxpool.txt"
`define OUTPUT_FILEPATH6   "./out_detection.txt"
`define OUTPUT_FILEPATH7   "./doc2.txt"

`define INPUT_FILEPATH1  "./main_image_matrix_doc2.txt"
`define INPUT_FILEPATH2  "./pattern_matrix.txt"
`define INPUT_FILEPATH7  "./laplacian.txt"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2018 01:50:12 PM
// Design Name: 
// Module Name: conv_feature_extraction
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


module top_module (
	input go, 
	input clk,
	input reset,
	output  reg full_done
  );

reg end_reach;	
reg signed [32:0] main[0:149599];
reg [32:0] pattern[0:809];
reg signed [3:0] laplacian [0:8] ;
reg [11:0]s;
wire [9:0] extr_main_width, extr_main_height, extr_pat_width, extr_pat_height , maxpool_out_width ,maxpool_out_height;
wire [9:0]  inter_out_width , inter_out_height ;

reg signed [31:0] out1, out2, sum , out3, sum1, max, overall_max, content, threshold;
reg signed [8:0] data1 , data2 ;

//reg signed [32:0] data_out_main [0:148043];
//reg signed [32:0] data_out_pattern [0:699];
//reg signed [32:0] inter_conv_out [0:129053];
//reg signed [32:0] maxpool_out [0:1270];

reg  input_rdy  , feature_ext_en_pat , feature_ext_en_main , inter_conv_en , maxpool_en , detection_done, detection_en, full_conv_end1  ;
reg signed [3:0] data11, data22;
wire kk ;
integer  file_outbw_main ,file_outbw_detectionh, file_outbw_pat , file_outbw_interconv , file_outbw_interconvHEX, file_outbw_maxpool , file_outbw_detection; 
parameter [2:0] step0 = 3'b000, step1 = 3'b001, step2 = 3'b010, step3 = 3'b011 , step4 = 3'b100 , step5 = 3'b101 ;
wire [18:0] addr, addr1,  write_address , write_address1 , address_pat , address_main, inter_add1, inter_add2, inter_write_address , maxpool_add1, maxpool_add2, maxpool_write_address;
reg [10:0] det_address;
wire full_conv_end_main , full_conv_end_pat , inter_full_conv_end, dotsum1_end, dotsum2_end, inter_end_reach, inter_dotsum_end ,maxpool_patch_end , maxpool_done ;
reg [2:0] current_state, next_state ;
reg signed [31:0] kr, prod;
reg [18:0] add;

initial begin
	input_rdy = 0;
	file_outbw_main = $fopen(`OUTPUT_FILEPATH1, "w");		
	file_outbw_pat = $fopen(`OUTPUT_FILEPATH2, "w");	
	file_outbw_interconv = $fopen(`OUTPUT_FILEPATH3, "w");		
	file_outbw_interconvHEX = $fopen(`OUTPUT_FILEPATH4, "w");		
		
	file_outbw_maxpool = $fopen(`OUTPUT_FILEPATH5, "w");	
	file_outbw_detection = $fopen(`OUTPUT_FILEPATH6, "w");	
	file_outbw_detectionh = $fopen(`OUTPUT_FILEPATH7, "w");	
	
	$readmemh(`INPUT_FILEPATH1 , main );
	$readmemh(`INPUT_FILEPATH2, pattern );
	$readmemb(`INPUT_FILEPATH7, laplacian );
	
	/*$readmemh(`OUTPUT_FILEPATH4, inter_conv_out );	
	inter_out_width = 10'b0100111010;
	inter_out_height  =  10'b0110011011;*/
	
	full_done = 0;
	input_rdy = 1;
	feature_ext_en_pat = 0;
	feature_ext_en_main = 0;
	inter_conv_en = 0;
	detection_en = 0;
	maxpool_en = 0;
	out1 <= 32'b0;
	out2 <= 32'b0;
	out3 <= 32'b0;
	max = 32'b0;
	overall_max = 32'b0;
	det_address = 0;
	full_done =0;
end



conv conv_main_inst (.stride(5'b00001), .conv_enable(feature_ext_en_main) , .address1(address_main) , .address2(addr), .write_address(write_address), .clk(clk) ,  .end_reach(end_reach1) , .dot_sum_end(dotsum1_end) , .full_conv_end(full_conv_end_main), .reset(reset) ,  .w1(10'b0101010100) , .h1(10'b0110111000) , 
 .w2(10'b0000000011) , .h2(10'b0000000011) , .width(extr_main_width) , .height(extr_main_height));


conv conv_pattern_inst (.stride(5'b00001), .conv_enable(feature_ext_en_pat) ,  .address1(address_pat) , .address2(addr1), .write_address(write_address1),  .clk(clk) ,   .end_reach(end_reach2) ,  .dot_sum_end(dotsum2_end) , .full_conv_end(full_conv_end_pat), .reset(reset) ,  .w1(10'b0000011011) , .h1(10'b0000011110) , 
  .w2(10'b0000000011) , .h2(10'b0000000011),  .width(extr_pat_width) , .height(extr_pat_height) );

conv inter_conv_inst (.stride(5'b00001), .conv_enable(inter_conv_en) ,  .address1(inter_add1) , .address2(inter_add2), .write_address(inter_write_address),  .clk(clk) ,   .end_reach(inter_end_reach) ,  .dot_sum_end(inter_dotsum_end) , .full_conv_end(inter_full_conv_end), .reset(reset) ,  .w1(extr_main_width) , .h1(extr_main_height) , 
  .w2(extr_pat_width) , .h2(extr_pat_height),  .width(inter_out_width) , .height(inter_out_height) );


maxpool_new maxpool_inst (.stride(5'b01010), .maxpool_enable(maxpool_en) ,  .address1(maxpool_add1)  , .write_address(maxpool_write_address),  .clk(clk) ,     .patch_end(maxpool_patch_end) , .maxpool_done(maxpool_done), .reset(reset) ,  .w1(inter_out_width) , .h1(inter_out_height) ,    .w2(5'b01010) , .h2(5'b01010),  .width(maxpool_out_width) , .height(maxpool_out_height) );




always @(posedge clk or posedge reset) // State register
	if (reset) current_state <= step0;
	else current_state <= next_state;


always @* begin				// Next-state logic
	
	data11 = laplacian[addr];
	data22 = laplacian[addr1];
	data1 = { main[address_main][8:0]};
	data2 = { pattern[address_pat][8:0]};
	
	case (current_state)			
		step0:  	if (!input_rdy) next_state = step0;
					else if (go) next_state = step1;
		step1: 	begin
						//add = addr;
						feature_ext_en_main =1;
						if (full_conv_end_main) begin
							feature_ext_en_main = 0;
							next_state = step2;
						end
					end
		step2: 	begin
						feature_ext_en_pat =1;
						//add = addr1;
						feature_ext_en_main = 0;
						
						if (full_conv_end_pat) begin
							feature_ext_en_pat = 0;
							$fclose(file_outbw_main);
							$fclose(file_outbw_pat);
							next_state = step3;
						end
					end
						
		step3:	begin
						inter_conv_en = 1;
						if (inter_full_conv_end) begin
							inter_conv_en= 0;
							next_state = step4;
							$fclose(file_outbw_interconv);
							$fclose(file_outbw_interconvHEX);
						end
					
					end
					
		step4: 	begin
						maxpool_en = 1;
						if (maxpool_done) begin
							maxpool_en = 0;
							$fclose(file_outbw_maxpool);
							next_state = step5;
						end
					end
					
		step5 :  begin
						detection_en =1;
						if (detection_done) begin
							detection_en = 0;
							full_done = 1;
							$fclose(file_outbw_detection);
							$fclose(file_outbw_detectionh);
							next_state = step0;
							input_rdy = 0;
						end
					end
	endcase
end



always @(posedge clk) begin		//output logic
	case (current_state)
		step0 :  begin 
					detection_done = 0;
					end
		step1 :	begin	
					if (feature_ext_en_main) begin			//main image feature extraction
						if (!full_conv_end_main) begin
							kr = data1 * data11;
							sum = kr + out1;
							out1 = !reset ? sum : 32'b0;  
							if (dotsum1_end) begin
								main[(write_address-1)] = out1;
								$fwrite(file_outbw_main,  "%d\n" , out1 );
								out1 = 32'b0;
							end
						end
					end
					end
					
		step2 :	begin	
					if (feature_ext_en_pat) begin			
						if (!full_conv_end_pat) begin		//pattern feature extraction
							kr = data2 * data22;
							sum = kr + out2;
							out2 = !reset ? sum : 32'b0;  
							if (dotsum2_end) begin
								pattern[(write_address1 - 1)] = out2;
								$fwrite(file_outbw_pat,  "%d\n" , out2 );
								out2 = 32'b0;
							end
						end
					end
					end
					
		step3 :	if (inter_conv_en && (!inter_full_conv_end)) 	 begin		//inter convolution
							prod = main[inter_add1] * pattern[inter_add2];
							sum1 = prod + out3;
							out3 = !reset ? sum1 : 32'b0;  
							if (inter_dotsum_end) begin
								main[(inter_write_address - 1)] = out3;
								$fwrite(file_outbw_interconv,  "%d\n" , out3 );
								$fwrite(file_outbw_interconvHEX,  "%x\n" , out3 );
								out3 = 32'b0;
							end						
					end 
					
		
		step4: if (maxpool_en && (!maxpool_done)) 	 begin		//maxpool
							content  = main[maxpool_add1];
							if (content > max) 	max = main[maxpool_add1];
							if (content > overall_max) 	overall_max = main[maxpool_add1];
							
							if (maxpool_patch_end) begin
								main[(maxpool_write_address - 1)] = max;								
								$fwrite(file_outbw_maxpool,  "%d\n" , max );
								max = 32'b0;
							end 
					end 
						
						
		step5:  begin		//detection
					  threshold = (overall_max >> 1) + (overall_max >> 3) ;		// threshold = 0.625 = (0.5 + 0.125) 
					  if (detection_en) begin
							if (main[det_address] > threshold )  s = {22'b0};
							else s = {12'b11111111};
							$fwrite(file_outbw_detectionh,  "%h\n" , s  );
							$fwrite(file_outbw_detection,  "%d\n" , s  );
							det_address =  det_address + 1;
							if (det_address == 11'd1271)  detection_done=1;
					  end 
				  end
				
	endcase			
end



endmodule 