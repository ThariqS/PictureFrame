/*
* reads phototransistor
* sends to serial monitor
*/
//#include "AVR035.h"
#define orangeLED PORTB, 4
#define redLED PORTB, 2
#define SAMPLE_RATE 2000 // milleseconds between adc reads

int photoPin = 5;
int level = 0;
int sampleRate = 2000; // ms between light readings
uint8_t incomingByte = 0;
unsigned long currentTime = millis();
unsigned long startTime = currentTime;
int ledPin =  13; 

void setup()                    // run once, when the sketch starts
{
//SETBITMASK(DDRB, 0x14);
Serial.begin(57600);

Serial.println("Started...");
}

void loop()                     // run over and over again
{
/*  currentTime = millis();
  if( currentTime - startTime >= SAMPLE_RATE )
  {
    level = analogRead(photoPin);
    Serial.print(level, DEC);
    startTime = millis();
  }*/
  if (Serial.available() > 0) {
    // we have data on the serial line, get it
    incomingByte = Serial.read();
    switch (incomingByte) {
      case 100:
          digitalWrite(ledPin, HIGH);   
         // delay(5000);                 
         // digitalWrite(ledPin, LOW);                   
        break;
      default:
          digitalWrite(ledPin, LOW);  
         break;
    }
  }
}
