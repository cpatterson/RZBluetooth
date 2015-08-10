//
//  CBPeripheral+RZBRepresentation.m
//  RZBluetooth
//
//  Created by Brian King on 8/8/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "CBPeripheral+RZBRepresentation.h"
#import "CBPeripheral+RZBExtension.h"
#import "CBPeripheral+RZBHelper.h"

#import "RZBRepresentation.h"
#import "RZBCharacteristicSerializer.h"
#import "RZBErrors.h"

@implementation CBPeripheral (RZBRepresentation)

- (void)rzb_fetchRepresentation:(id<RZBServiceRepresentation>)representation
                           keys:(NSArray *)keys
                     completion:(RZBRepresentationBlock)completion
{
    NSDictionary *UUIDsByKey = [representation characteristicUUIDsByKey];
    NSArray *allKeys = [UUIDsByKey allKeys];
    if (keys) {
        for (NSString *key in keys) {
            if (![allKeys containsObject:key]) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"representation %@ does not have key '%@'", representation, key];
            }
        }
    }
    else {
        keys = allKeys;
    }
    __block NSError *lastError = nil;
    __block NSObject *result = nil;
    if (keys.count > 1) {
        if (representation.class == nil) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"representation %@ must return a class if multiple keys are available", representation];
        }

        result = [[representation.class alloc] init];
    }
    else if (keys.count == 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Must specify keys"];
    }

    dispatch_group_t done = dispatch_group_create();
    for (NSString *key in keys) {
        // Skip reads to non-readable properties.
        CBCharacteristicProperties property = [representation characteristicPropertiesForKey:key];
        if ((property & CBCharacteristicPropertyRead) != CBCharacteristicPropertyRead) {
            continue;
        }
        dispatch_group_enter(done);
        id<RZBCharacteristicSerializer> serializer = [representation serializerForKey:key];

        [self rzb_readCharacteristicUUID:UUIDsByKey[key]
                             serviceUUID:[representation serviceUUID]
                              completion:^(CBCharacteristic *characteristic, NSError *error) {
                                  if (error == nil) {
                                      id value = [serializer objectWithCharacteristicData:characteristic.value error:&error];
                                      if (value) {
                                          if (result) {
                                              [result setValue:value forKey:key];
                                          }
                                          else {
                                              result = value;
                                          }
                                      }
                                  }
                                  BOOL isDiscoveryError = ([[error domain] isEqualToString:RZBluetoothErrorDomain] &&
                                                           [error code] == RZBluetoothDiscoverCharacteristicError);
                                  if (error && isDiscoveryError == NO) {
                                      lastError = error;
                                  }
                                  dispatch_group_leave(done);
                              }];
    }
    dispatch_group_notify(done, self.rzb_queue, ^{
        completion(result, lastError);
    });
}

@end
