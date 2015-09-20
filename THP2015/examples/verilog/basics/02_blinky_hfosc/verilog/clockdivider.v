`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2015 21:49:21
// Design Name: 
// Module Name: clockdivider
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


module clockdivider #(
  parameter bits = 32
  )(
  input clkin,
  input[bits-1:0] div,
  output clkout
);

reg [bits-1:0] count = 0;
always @(posedge clkin)
begin
  if(count == 0)
    count = div;
  count = count - {{bits-1{1'b0}},1'b1};
end

assign clkout = (div == 1'b0) ? 1'b0 : 
                (div == 1'b1) ? clkin :
                (count == {bits{1'b0}});

endmodule
