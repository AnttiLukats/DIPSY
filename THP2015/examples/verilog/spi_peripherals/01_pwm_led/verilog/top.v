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


module top(
  output pin_led,
  input spi_sck,
  input spi_mosi,
  input spi_cs
);

/*******************************************************************************
SPI and related signals
*******************************************************************************/
wire[7:0] spi_dout;
wire spi_drdy;
wire spi_cs_falling;
wire spi_cs_rising;
spi spi(
  .SYSCLK(sysclk),
  .SCK(spi_sck),
  .MOSI(spi_mosi),
  .MISO(),
  .CS(spi_cs),
  .DIN(8'h0),
  .DOUT(spi_dout),
  .DRDY(spi_drdy),
  .CS_falling(spi_cs_falling),
  .CS_rising(spi_cs_rising)
);

reg[7:0] comp = 0;
always @(posedge sysclk)
  if (spi_cs_rising == 1'b1)
    comp = spi_dout;

wire pwmclk;
wire pwm_out;
pwm pwm(
  .clkin(pwmclk),
  .comp(comp),
  .pwm_out(pwm_out)
);

SB_RGBA_DRV #(
  .CURRENT_MODE("0b0"),
  .RGB0_CURRENT("0b000001"),
  .RGB1_CURRENT("0b000001"),
  .RGB2_CURRENT("0b000001")
) drv (
  .CURREN(1'b1),
  .RGBLEDEN(1'b1),
  .RGB0PWM(pwm_out), 
  .RGB0(pin_led)
);

SB_HFOSC #(.CLKHF_DIV("0b00")
) osc(
  .CLKHFEN(1'b1), // enable
  .CLKHFPU(1'b1),  // power up
  .CLKHF(sysclk)   // output to sysclk
) /* synthesis ROUTE_THROUGH_FABRIC=0 */;

clockdivider #(.bits(2)) div (
  .clkin(sysclk),
  .clkout(pwmclk),
  .div(2'd2)
);

endmodule
