`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: CR
// 
// Create Date: 14.09.2015 23:24:27
// Design Name: 
// Module Name: WS2812B_v0_1
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


module AXIS_WS2812B_cr_v0_1 #(
  parameter C_S_AXIS_TDATA_WIDTH = 32
  )(
  output DOUT,
  input s_axis_aclk,
  input s_axis_aresetn,
  output s_axis_tready,
  input [C_S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
  input s_axis_tlast,
  input s_axis_tvalid
);

`define bitcount_top 5'd23
`define subbitcount_top 3'd3
`define subbittimer_top 5'd17

reg[4:0] bitcount = 0;
reg[2:0] subbitcount = 0;
reg[23:0] ws_shiftreg = 0;
reg[2:0] bit_shiftreg = 0;

reg[4:0] subbittimer = 0;
wire subbitclk_enable;

wire ready;
assign s_axis_tready = ready;

wire transfer;
assign transfer = s_axis_tvalid && ready;

always @(posedge s_axis_aclk)
begin
  if(transfer == 1'b1)
  begin
    bitcount = `bitcount_top;
    subbitcount = `subbitcount_top;
    subbittimer = `subbittimer_top;
    ws_shiftreg = s_axis_tdata[23:0];
    bit_shiftreg = (ws_shiftreg[23] == 1'b1) ? 3'b111 : 3'b100;
  end
  else if (subbitclk_enable == 1'b1)
  begin
    if(subbittimer == 0)
    begin
      subbittimer = `subbittimer_top;
      if(subbitcount == 0)
      begin
        bit_shiftreg = (ws_shiftreg[23] == 1'b1) ? 3'b111 : 3'b100;
        subbitcount = `subbitcount_top;
        if(bitcount != 0)
        begin
          ws_shiftreg = {ws_shiftreg[22:0],1'b0};
          bitcount = bitcount - 5'd1;
        end
      end
      else
      begin
        bit_shiftreg = {bit_shiftreg[1:0],1'b0};
        subbitcount = subbitcount - 3'd1;
      end 
    end
    else
      subbittimer = subbittimer - 5'd1;
  end
end

assign subbitclk_enable = ((bitcount == 1'b0) && (subbitcount == 1'b0) && (subbittimer == 1'b0)) ? 1'b0 : 1'b1;
assign ready = ~subbitclk_enable;
assign DOUT = bit_shiftreg[2];

endmodule