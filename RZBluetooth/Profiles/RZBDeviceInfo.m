//
//  CBPeripheral+RZBDeviceInfo.m
//  RZBluetooth
//
//  Created by Brian King on 8/4/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "RZBDeviceInfo.h"
#import "CBPeripheral+RZBRepresentation.h"

NSString *const RZBDeviceInfoModelNumberKey = @"modelNumber";

@implementation RZBDeviceInfo

+ (id<RZBServiceRepresentation>)serviceRepresentation;
{
    return (id)self.class;
}

+ (CBUUID *)serviceUUID
{
    return [CBUUID UUIDWithString:@"180A"];
}

+ (NSDictionary *)characteristicUUIDsByKey
{
    return @{@"modelNumber"     : [CBUUID UUIDWithString:@"2a24"],
             @"serialNumber"    : [CBUUID UUIDWithString:@"2a25"],
             @"firmwareRevision": [CBUUID UUIDWithString:@"2a26"],
             @"hardwareRevision": [CBUUID UUIDWithString:@"2a27"],
             @"manufacturerName": [CBUUID UUIDWithString:@"2a29"],
             };
}

+ (CBCharacteristicProperties)characteristicPropertiesForKey:(NSString *)key
{
    return CBCharacteristicPropertyRead;
}

+ (id<RZBCharacteristicSerializer>)serializerForKey:(NSString *)key
{
    return [RZBCharacteristicSerializer utfStringSerializer];
}

@end

@implementation CBPeripheral (RZBDeviceInfo)


- (void)rzb_fetchDeviceInformationKeys:(NSArray *)deviceInfoKeys
                            completion:(RZBDeviceInfoCallback)completion
{
    [self rzb_fetchRepresentation:[RZBDeviceInfo serviceRepresentation]
                             keys:deviceInfoKeys
                       completion:completion];
}

@end
