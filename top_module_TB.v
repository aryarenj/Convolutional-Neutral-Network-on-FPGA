`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:42:21 05/07/2018
// Design Name:   top_module
// Module Name:   C:/Users/Arya/Documents/Xilinx_Work/Final_proj/top_module_TB.v
// Project Name:  Final_proj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_module_TB;

	// Inputs
	reg go;
	reg clk;
	reg reset;

	// Outputs
	wire full_done;

	// Instantiate the Unit Under Test (UUT)
	top_module uut (
		.go(go), 
		.clk(clk), 
		.reset(reset), 
		.full_done(full_done)
	);
	always begin
		#5;
		clk = ~clk;
	end
		
	initial begin
		
		// Initialize Inputs
		clk = 0;
		go = 0;
		reset = 1;
		#10;
		go = 1;
		#10
		go = 0;
		reset = 0;
		
		
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
      
endmodule

