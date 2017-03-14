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
    CBPeripheral *controllerOne;
    CBPeripheral *controllerTwo;
    
    Float32 xAccel;
    Float32 yAccel;
    Float32 zAccel;
    
    BOOL autoConnect;
    
}

@property (assign) Float32 xAccel;
@property (assign) Float32 yAccel;
@property (assign) Float32 zAccel;

- (void) setup;
- (void) startScan;
- (void) stopScan;
- (BOOL) isLECapableHardware;
- (void) connectToPeripheral;
- (void) disconnectPeripherals;

- (void) updateX:(NSData *)data;
- (void) updateY:(NSData *)data;
- (void) updateZ:(NSData *)data;

@end


