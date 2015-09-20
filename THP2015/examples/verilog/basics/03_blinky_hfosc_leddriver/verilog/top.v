module top (
  output pin_led
);

reg led = 0;
SB_RGBA_DRV #(
  .CURRENT_MODE("0b0"),
  .RGB0_CURRENT("0b000001"),
  .RGB1_CURRENT("0b000001"),
  .RGB2_CURRENT("0b000001")
) drv (
  .CURREN(1'b1),
  .RGBLEDEN(1'b1),
  .RGB0PWM(led), 
  .RGB0(pin_led)
);

wire sysclk;

SB_HFOSC #(.CLKHF_DIV("0b00")) osc (
  .CLKHFEN(1'b1),
  .CLKHFPU(1'b1),
  .CLKHF(sysclk) 
) /* synthesis ROUTE_THROUGH_FABRIC = 0 */;

wire clkout;
clockdivider #(.bits(28)) div(
  .clkin(sysclk),
  .clkout(clkout),
  .div(28'd48000000)
);

always @(posedge clkout)
led = ~led;

endmodule
