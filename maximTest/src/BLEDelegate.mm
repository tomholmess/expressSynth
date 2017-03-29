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


- (void) startCentralManager
{
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

- (void) scanForPeripherals
{
    
    [manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
    
    
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI

{
    
    NSMutableArray *peripherals = [self mutableArrayValueForKey:@"controller"];
    
}



- (void) connectToPeripherals
{
    
    [manager stopScan];
    [manager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    
}

- (void) discoverServices
{
    
/*    [peripheral discoverServices:[]
  */
}

- (void) readCharacteristics
{
    
    
    
}@end
