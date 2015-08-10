//
//  RZBSimulatedDevice.m
//  RZBluetooth
//
//  Created by Brian King on 8/4/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "RZBSimulatedDevice.h"
#import "RZBMockPeripheralManager.h"
#import "RZBSimulatedCentral+Private.h"
#import "RZBCharacteristicSerializer.h"

@interface RZBSimulatedDevice ()

@property (strong, nonatomic, readonly) NSMutableDictionary *readHandlers;

@end

@implementation RZBSimulatedDevice

- (instancetype)initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *)options peripheralManagerClass:(Class)peripheralManagerClass
{
    self = [super init];
    if (self) {
        _identifier = [NSUUID UUID];
        _readHandlers = [NSMutableDictionary dictionary];
        _peripheralManager = [[peripheralManagerClass alloc] initWithDelegate:self queue:queue];
    }
    return self;
}

- (CBMutableService *)serviceForRepresentable:(id<RZBServiceRepresentable>)representable isPrimary:(BOOL)isPrimary
{
    CBMutableService *service = [[CBMutableService alloc] initWithType:[representable.class serviceUUID] primary:isPrimary];
    id <RZBServiceRepresentation> representation = [representable.class serviceRepresentation];
    NSDictionary *characteristicsByUUID = [representation characteristicUUIDsByKey];
    NSMutableArray *characteristics = [NSMutableArray array];
    [characteristicsByUUID enumerateKeysAndObjectsUsingBlock:^(NSString *key, CBUUID *UUID, BOOL *stop) {
        CBCharacteristicProperties properties = [representable.class characteristicPropertiesForKey:key];
        CBAttributePermissions permissions = CBAttributePermissionsReadable | CBAttributePermissionsWriteable;
        id<RZBCharacteristicSerializer> serialzer = [representation serializerForKey:key];

        id value = [representable valueForKey:key];

        if (value) {
            NSData *data = [serialzer characteristicDataForObject:value error:NULL];
            
            CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:UUID
                                                                                         properties:properties
                                                                                              value:data
                                                                                        permissions:permissions];
            [characteristics addObject:characteristic];
        }
    }];
    service.characteristics = characteristics;
    return service;
}

- (void)addBluetoothRepresentable:(id<RZBServiceRepresentable>)bluetoothRepresentable isPrimary:(BOOL)isPrimary;
{
    NSParameterAssert(bluetoothRepresentable);
    CBMutableService *service = [self serviceForRepresentable:bluetoothRepresentable isPrimary:isPrimary];
    [self.peripheralManager addService:service];
}

- (void)addReadCallbackForCharacteristicUUID:(CBUUID *)characteristicUUID handler:(RZBSimulatedDeviceRead)handler;
{
    NSParameterAssert(characteristicUUID);
    NSParameterAssert(handler);
    self.readHandlers[characteristicUUID] = [handler copy];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error adding service %@", service);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    RZBSimulatedDeviceRead read = self.readHandlers[request.characteristic.UUID];
    if (read) {
        CBATTError result = read(request);
        [peripheral respondToRequest:request withResult:result];
    }
    else {
        NSLog(@"Un-handled read for %@", request);
    }
}

@end
