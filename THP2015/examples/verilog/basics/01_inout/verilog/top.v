module top (
  input pin_in,
  output pin_out
);

wire mywire;

SB_IO_OD #(
  .PIN_TYPE(6'b000001),
  .NEG_TRIGGER(1'b0)
) pin_in_driver (
  .PACKAGEPIN(pin_in),
  .DIN0(mywire)
);

SB_IO_OD #(
  .PIN_TYPE(6'b011001),
  .NEG_TRIGGER(1'b0)
) pin_out_driver (
  .PACKAGEPIN(pin_out),
  .DOUT0(mywire)
);

endmodule
