`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2015 18:31:57
// Design Name: 
// Module Name: spi
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


module spi(
    input SYSCLK,
    input SCK,
    input MOSI,
    output MISO,
    input CS,
    input [7:0] DIN,
    output reg [7:0] DOUT,
    output reg DRDY,
    output CS_falling,
    output CS_rising
    );
    
reg[2:0] SCKsample;
reg[2:0] CSsample;
always @(posedge SYSCLK)
  SCKsample <= {SCKsample[1:0], SCK};
always @(posedge SYSCLK)
  CSsample <= {CSsample[1:0], CS};

wire SCK_rising = (SCKsample[2:1] == 2'b01);
wire SCK_falling = (SCKsample[2:1] == 2'b10);
wire CS_active = ~CSsample[1];
assign CS_falling = (CSsample[2:1] == 2'b10);
assign CS_rising = (CSsample[2:1] == 2'b01);

reg[3:0] bitcnt = 0;
reg[7:0] rx = 0;
reg[7:0] tx = 0;
reg txout;

always @(posedge SYSCLK)
begin
  if(CS_falling || (bitcnt == 8))
  begin
    bitcnt = 0;
    tx = DIN;
  end
  else if(CS_active)
  begin
    if(SCK_rising)
    begin
      rx = {rx[6:0],MOSI};
      bitcnt = bitcnt + 4'b0001;
    end
    else if(SCK_falling)
    begin
      txout = tx[7];
      tx = {tx[6:0],1'b0};
    end
  end
end

assign MISO = (~CS) ? txout : 1'bz;

wire byte_received = (bitcnt == 8);
always @(posedge byte_received)
  DOUT = rx;

//output reg DRDY = 0;
always @(posedge SYSCLK)
begin
  DRDY = byte_received;
end

endmodule
