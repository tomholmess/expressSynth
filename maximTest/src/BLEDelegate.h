//
//  BLEDelegate.h
//  expressSynthVersionOne
//
//  Created by Tom Holmes on 21/02/2017.
//
//

#import <IOBluetooth/IOBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDelegate : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
@public    
    CBCentralManager *manager;
    CBPeripheral *peripheral;
    
    Float32 xAccel;
    Float32 yAccel;
    Float32 zAccel;

    
}

@property (assign) Float32 xAccel;
@property (assign) Float32 yAccel;
@property (assign) Float32 zAccel;

- (void) startCentralManager;
- (void) scanForPeripherals;
- (void) connectToPeripherals;
- (void) discoverServices;
- (void) readCharacteristics;

- (void) updateX:(NSData *)data;
- (void) updateY:(NSData *)data;
- (void) updateZ:(NSData *)data;

@end


