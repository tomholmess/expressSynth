//
//  BLEDelegate.m
//  expressSynthVersionOne
//
//  Created by Tom Holmes on 21/02/2017.
//
//

#import <Foundation/Foundation.h>
#import "BLEDelegate.h"

@implementation BLEDelegate

@synthesize xAccel;
@synthesize yAccel;
@synthesize zAccel;

- (void) setup
{
    autoConnect = TRUE;
    xAccel = 0.21;
}


/*
 Connect to controllers
 */
- (void) connectToPeripheral
{
    if(![controllerOne isConnected]) {
        [self stopScan];
        [manager connectPeripheral:controllerOne options:nil];
        [manager connectPeripheral:controllerTwo options:nil];
    }

    
}

/*
 Disconnect controllers when application terminates
 */
- (void) disconnectPeripherals
{
    if(controllerOne)
    {
        [manager cancelPeripheralConnection:controllerOne];
    }
    
    if(controllerTwo)
    {
        [manager cancelPeripheralConnection:controllerTwo];
    }
    
}

/*
 Uses CBCentralManager to check whether the current platform/hardware supports Bluetooth LE. An alert is raised if Bluetooth LE is not enabled or is not supported.
 */
- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([manager state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    NSLog(@"Central manager state: %@", state);
    
}



/* Update X-Acceleration data received from device */
-(void) updateX:(NSData *)data
{
    const uint8_t * reportData = (uint8_t*)[data bytes];
    uint16_t ms = 0;

    if ((reportData[0] & 0x01) == 0) {
        /* uint8 bpm */
        ms = reportData[1];
    }
    else
    {
        /* uint16 bpm */
        ms = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }

    uint16_t oldMs = self.xAccel;
    self.xAccel = ms;

}

/* Update Y-Acceleration data received from device */
-(void) updateY:(NSData *)data
{
    const uint8_t * reportData = (uint8_t*)[data bytes];
    uint16_t ms = 0;

    if ((reportData[0] & 0x01) == 0) {
        /* uint8 bpm */
        ms = reportData[1];
    }
    else
    {
        /* uint16 bpm */
        ms = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }

    uint16_t oldMs = self.yAccel;
    self.yAccel = ms;

}

/* Update Z-Acceleration data received from device */
-(void) updateZ:(NSData *)data
{
    const uint8_t * reportData = (uint8_t*)[data bytes];
    uint16_t ms = 0;

    if ((reportData[0] & 0x01) == 0) {
        /* uint8 bpm */
        ms = reportData[1];
    }
    else
    {
        /* uint16 bpm */
        ms = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }

    uint16_t oldMs = self.zAccel;
    self.zAccel = ms;

}


/*
 Request CBCentralManager to scan for controllers using service UUID 0x180D
 */
- (void) startScan
{
    /* Search for controllerOne UUID 180D */
    [manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
    /* Search for controllerTwo UUID 180E */
    [manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180E"]] options:nil];
    [self stopScan];
    
    
    [manager connectPeripheral:controllerOne options:nil];
    
}
/*
 Request CBCentralManager to stop scanning for heart rate peripherals
 */
- (void) stopScan
{
    [manager stopScan];
}

#pragma mark - CBPeripheral delegate methods
/*
 Invoked upon completion of a -[discoverServices:] request.
 Discover available characteristics on interested services
 */
- (void) controllerOne:(CBPeripheral *)aControllerOne didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aControllerOne.services)
    {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        /* Heart Rate Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])
        {
            [aControllerOne discoverCharacteristics:nil forService:aService];
        }
        
    }
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 Perform appropriate operations on interested characteristics
 */
- (void) controllerOne:(CBPeripheral *)aControllerOne didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Set notification on heart rate measurement */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
            {
                [controllerOne setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found an X-Acceleration Characteristic");
            }
            /* Set notification on resting rate measurement */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]])
            {
                [controllerOne setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found a Y-Acceleration Characteristic");
            }
            /* Set notification on resting rate measurement */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A39"]])
            {
                [controllerOne setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found a Z-Acceleration Characteristic");
            }
        }
    }
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void) controllerOne:(CBPeripheral *)aControllerOne didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    /* Updated value for heart rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
    {
        if( (characteristic.value)  || !error )
        {
            /* Update UI with heart rate data */
            [self updateX:characteristic.value];
        }
    }
    /* Updated value for resting rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]])
    {
        if( (characteristic.value) || !error ) {
            /* Update UI with resting rate data */
            [self updateY:characteristic.value];
        }
    }
    /* Updated value for resting rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A39"]])
    {
        if( (characteristic.value) || !error ) {
            /* Update UI with resting rate data */
            [self updateZ:characteristic.value];
        }
    }
}

@end
