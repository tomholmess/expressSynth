//
//  BLEDelegate.h
//  expressSynthVersionOne
//
//  Created by Tom Holmes on 21/02/2017.
//
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDelegate : NSObject <NSApplicationDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *manager;
    CBPeripheral *controllerOne;
    CBPeripheral *controllerTwo;
    
    uint16_t xAccel;
    uint16_t yAccel;
    uint16_t zAccel;
    
}

@property (assign) uint16_t xAccel;
@property (assign) uint16_t yAccel;
@property (assign) uint16_t zAccel;

- (void) startScan;
- (void) stopScan;
- (BOOL) isLECapableHardware;
- (void) connectToPeripheral;
- (void) disconnectPeripherals;

- (void) updateX:(NSData *)data;
- (void) updateY:(NSData *)data;
- (void) updateZ:(NSData *)data;

@end


