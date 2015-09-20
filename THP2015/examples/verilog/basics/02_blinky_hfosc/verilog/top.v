module top (
  output pin_led
);

reg led = 0;
SB_IO_OD #(             // open drain IP instance
  .PIN_TYPE(6'b011001)  // configure as output
) pin_out_driver (
  .PACKAGEPIN(pin_led), // connect to this pin
  .DOUT0(led)           // output the state of "led"
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
