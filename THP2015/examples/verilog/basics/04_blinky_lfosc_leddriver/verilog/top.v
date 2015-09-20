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

SB_LFOSC osc (
  .CLKLFEN(1'b1),
  .CLKLFPU(1'b1),
  .CLKLF(sysclk) 
) /* synthesis ROUTE_THROUGH_FABRIC = 0 */;

wire clkout;
clockdivider #(.bits(14)) div(
  .clkin(sysclk),
  .clkout(clkout),
  .div(14'd5000)
);

always @(posedge clkout)
led = ~led;

endmodule
