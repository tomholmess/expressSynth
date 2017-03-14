#include <Arduino.h>
#include <SPI.h>
#include <Wire.h>
#if not defined (_VARIANT_ARDUINO_DUE_X_) && not defined (_VARIANT_ARDUINO_ZERO_)
  #include <SoftwareSerial.h>
#endif

#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#include "Adafruit_Sensor.h"
#include "Adafruit_ADXL345_U.h"

#include "BluefruitConfig.h"

// Create the bluefruit object, either software serial...uncomment these lines
/*
SoftwareSerial bluefruitSS = SoftwareSerial(BLUEFRUIT_SWUART_TXD_PIN, BLUEFRUIT_SWUART_RXD_PIN);

Adafruit_BluefruitLE_UART ble(bluefruitSS, BLUEFRUIT_UART_MODE_PIN,
                      BLUEFRUIT_UART_CTS_PIN, BLUEFRUIT_UART_RTS_PIN);
*/

/* ...or hardware serial, which does not need the RTS/CTS pins. Uncomment this line */
// Adafruit_BluefruitLE_UART ble(BLUEFRUIT_HWSERIAL_NAME, BLUEFRUIT_UART_MODE_PIN);

/* ...hardware SPI, using SCK/MOSI/MISO hardware SPI pins and then user selected CS/IRQ/RST */
Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

/* ...software SPI, using SCK/MOSI/MISO user-defined SPI pins and then user selected CS/IRQ/RST */
//Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_SCK, BLUEFRUIT_SPI_MISO,
//                             BLUEFRUIT_SPI_MOSI, BLUEFRUIT_SPI_CS,
//                             BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);


// A small helper
void error(const __FlashStringHelper*err) {
  Serial.println(err);
  while (1);
}

/* Accerometer stuff */

Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified(12345);

float xAccel;
float yAccel;
float zAccel;

int32_t accelerometerID;
int32_t xAccelID;
int32_t yAccelID;
int32_t zAccelID;

/**************************************************************************/
/*!
    @brief  Sets up the HW an the BLE module (this function is called
            automatically on startup)
*/
/**************************************************************************/
void setup(void)
{
  
  accel.begin();
  accel.setRange(ADXL345_RANGE_2_G);
  accel.setDataRate(ADXL345_DATARATE_50_HZ );

  Serial.begin(9600);

  boolean success;

//  Serial.println(F("expressSynth Bluetooth Accelerometer Controller"));
//  Serial.println(F("---------------------------------------------------"));

  randomSeed(micros());

  /* Initialise the module */
//  Serial.print(F("Initialising the Bluefruit LE module: "));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
//  Serial.println( F("OK!") );
//
//  /* Perform a factory reset to make sure everything is in a known state */
//  Serial.println(F("Performing a factory reset: "));
  if (! ble.factoryReset() ){
       error(F("Couldn't factory reset"));
  }

  /* Disable command echo from Bluefruit */
  ble.echo(false);

//  Serial.println("Requesting Controller info:");
  /* Print Bluefruit information */
  ble.info();

  /* Change the device name to make it easier to find */
//  Serial.println(F("Setting device name to 'expressSynth Bluetooth Controller': "));

  if (! ble.sendCommandCheckOK(F("AT+GAPDEVNAME=expressSynthBluetoothController")) ) {
    error(F("Could not set device name?"));
  }

  /* Add the Controller definition */
  /* Service ID should be 1 */
  Serial.println(F("Adding the Bluetooth Controller definition (UUID = 0x180D): "));
  success = ble.sendCommandWithIntReply( F("AT+GATTADDSERVICE=UUID=0x180D"), &accelerometerID);
  if (! success) {
    error(F("Could not add Controller service"));
  }

  /* Add the X-Acceleration characteristic */
  /* Chars ID for Measurement should be 1 */
  Serial.println(F("Adding the X-Acceleration characteristic (UUID = 0x2A37): "));
  success = ble.sendCommandWithIntReply( F("AT+GATTADDCHAR=UUID=0x2A37, PROPERTIES=0x10, MIN_LEN=2, MAX_LEN=3, VALUE=00-40"), &xAccelID);
    if (! success) {
    error(F("Could not add X-Acceleration characteristic"));
  }

   /* Add the Y-Acceleration characteristic */
  /* Chars ID for Measurement should be 1 */
  Serial.println(F("Adding the Resting Rate Measurement characteristic (UUID = 0x2A38): "));
  success = ble.sendCommandWithIntReply( F("AT+GATTADDCHAR=UUID=0x2A38, PROPERTIES=0x10, MIN_LEN=2, MAX_LEN=3, VALUE=00-40"), &yAccelID);
    if (! success) {
    error(F("Could not add Y-Acceleration characteristic"));
  }

   /* Add the Z-Acceleration characteristic */
  /* Chars ID for Measurement should be 1 */
  Serial.println(F("Adding the Resting Rate Measurement characteristic (UUID = 0x2A39): "));
  success = ble.sendCommandWithIntReply( F("AT+GATTADDCHAR=UUID=0x2A39, PROPERTIES=0x10, MIN_LEN=2, MAX_LEN=3, VALUE=00-40"), &zAccelID);
    if (! success) {
    error(F("Could not add Z-Acceleration characteristic"));
  }



  /* Add the Heart Rate Service to the advertising data (needed for Nordic apps to detect the service) */
//  Serial.print(F("Adding Heart Rate Service UUID to the advertising payload: "));
  ble.sendCommandCheckOK( F("AT+GAPSETADVDATA=02-01-06-05-02-0d-18-0a-18") );

  /* Reset the device for the new service setting changes to take effect */
//  Serial.print(F("Performing a SW reset (service changes require a reset): "));
  ble.reset();

//  Serial.println();

}

/** Send randomized heart rate data continuously **/
void loop(void)
{

  sensors_event_t accelEvent;  
  accel.getEvent(&accelEvent);

  xAccel = accelEvent.acceleration.x;
  yAccel = accelEvent.acceleration.z;
  zAccel = accelEvent.acceleration.y;

//  Serial.print(F("X acceleration: ") );
  Serial.print("X");
  Serial.print(xAccel, 2);
//  
//  Serial.print(F(", Y acceleration: ") );
  Serial.print(" Y");
  Serial.print(yAccel, 2);
  
//  Serial.print(F(", Z acceleration: ") );
  Serial.print(" Z");
  Serial.println(zAccel, 2);

  delay(100);

  /* Bluetooth Command is sent when \n (\r) or println is called */
  /* AT+GATTCHAR=CharacteristicID,value */

  ble.print( F("AT+GATTCHAR=") );
  ble.print( xAccelID );
  ble.print( F(",00-") );
  ble.println(xAccel);

  ble.print( F("AT+GATTCHAR=") );
  ble.print( yAccelID );
  ble.print( F(",00-") );
  ble.println(yAccel);

  ble.print( F("AT+GATTCHAR=") );
  ble.print( zAccelID );
  ble.print( F(",00-") );
  ble.println(zAccel);

}
