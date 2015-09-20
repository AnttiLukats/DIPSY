#include <SPI.h>
#include <dipsydownloader.h>

extern const uint8_t bitmap[];
extern const size_t bitmap_size;

#define DIPSY_CRESETB 0
#define DIPSY_CDONE 1
#define DIPSY_SS 2

#define MY_PIN 14

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
  SPI.end();
  pinMode(MY_PIN, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWriteFast(MY_PIN, !digitalReadFast(MY_PIN));
  delay(500);
}
