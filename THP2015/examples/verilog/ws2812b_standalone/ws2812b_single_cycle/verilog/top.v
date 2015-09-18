module top(
  output PIN_DOUT,
  output PIN_LED
);

wire WS_DOUT;
SB_IO_OD #(
  .PIN_TYPE(6'b011001)
) driver_dout (
  .PACKAGEPIN(PIN_DOUT),
  .DOUT0(WS_DOUT)
);

wire valid;
wire led = ~valid;
SB_IO_OD #(
  .PIN_TYPE(6'b011001)
) driver_led (
  .PACKAGEPIN(PIN_LED),
  .DOUT0(led)
);

wire sysclk;

SB_HFOSC #(.CLKHF_DIV("0b00")
) osc(
  .CLKHFEN(1'b1),  // enable
  .CLKHFPU(1'b1),  // power up
  .CLKHF(sysclk)   // output to sysclk
) /* synthesis ROUTE_THROUGH_FABRIC=0 */;

wire[23:0] data;
wire ready;
AXIS_WS2812B_cr_v0_1 #(.C_S_AXIS_TDATA_WIDTH(24)) ws(
  .DOUT(WS_DOUT),
  .s_axis_aclk(sysclk),
  .s_axis_aresetn(1'b0),
  .s_axis_tready(ready),
  .s_axis_tdata(data),
  .s_axis_tvalid(valid)
);

reg[1:0] index;
reg[31:0] delaycounter;
always @(posedge sysclk)
begin
  delaycounter = delaycounter + 1;
  if(delaycounter == 48000000)
  begin
    delaycounter = 0;
    index = index + 2'd1;
  end
end

assign valid = (delaycounter == 0);

assign data = (index == 0) ? 24'h800000 :
              (index == 1) ? 24'h008000 :
              (index == 2) ? 24'h000080 :
                             24'h404040;

endmodule
