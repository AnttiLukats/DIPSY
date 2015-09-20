`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2015 23:16:44
// Design Name: 
// Module Name: tb
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


module pwm(
  output pwm_out,
  input clkin,
  input[7:0] comp
);

reg[7:0] counter = 0;

always @(posedge clkin)
begin
  counter = counter + 8'd1;
end

assign pwm_out = (comp > counter);

endmodule