#include <SPI.h>
#include <dipsydownloader.h>

extern const uint8_t bitmap_bin[];
extern const size_t bitmap_bin_size;

#define DIPSY_CRESETB 0
#define DIPSY_CDONE 1
#define DIPSY_SS 2

void setup() {
  // put your setup code here, to run once:
  while(!Serial.available());
  while(Serial.available()) Serial.read();

  SPI.begin();
  dipsy::ArrayConfig dipsyConfig(bitmap_bin_size, bitmap_bin);
  Serial.print("configuring dipsy...");
  if(dipsy::configure(DIPSY_CRESETB, DIPSY_CDONE, DIPSY_SS, SPI, dipsyConfig))
  {
    Serial.println("done");
    Serial.flush();
  }
  else
  {
    Serial.println("error");
    Serial.flush();
    while(1);
  }
  SPI.end();
}

void loop() {
}
