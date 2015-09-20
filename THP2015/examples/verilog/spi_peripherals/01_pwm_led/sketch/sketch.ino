#include <SPI.h>
#include <dipsydownloader.h>

extern const uint8_t bitmap[];
extern const size_t bitmap_size;

#define DIPSY_CRESETB 0
#define DIPSY_CDONE 1
#define DIPSY_SS 2

void setup() {
  // put your setup code here, to run once:
//  while(!Serial.available());
//  while(Serial.available()) Serial.read();
  delay(1000);
  SPI.begin();
  dipsy::ArrayConfig dipsyConfig(bitmap_size, bitmap);
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
  pinMode(DIPSY_SS, OUTPUT);
  digitalWriteFast(DIPSY_SS, 1);
  delay(20);
}

void loop() {
  static uint8_t index = 0;
  static const uint8_t pwm_values[4] = {0, 0x40, 0x80, 0xFF};
  // put your main code here, to run repeatedly:
  digitalWriteFast(DIPSY_SS, 0);
  SPI.transfer(pwm_values[index & 0b11]);
  digitalWriteFast(DIPSY_SS, 1);
  index++;
  delay(500);
}
