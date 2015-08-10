//
//  RZBCharacteristicSerializer.m
//  RZBluetooth
//
//  Created by Brian King on 8/8/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "RZBCharacteristicSerializer.h"

@interface RZBCharacteristicSerializerUInt8 : NSObject <RZBCharacteristicSerializer>
@end
@implementation RZBCharacteristicSerializerUInt8

- (NSNumber *)objectWithCharacteristicData:(NSData *)data error:(NSError **)error
{
    uint8_t value = 0;
    [data getBytes:&value length:sizeof(uint8_t)];
    return [NSNumber numberWithInt:value];
}

- (NSData *)characteristicDataForObject:(id)object error:(NSError **)error
{
    uint8_t value = [object unsignedIntValue];
    return [NSData dataWithBytes:&value length:sizeof(uint8_t)];
}

@end

@interface RZBCharacteristicSerializerUInt16 : NSObject <RZBCharacteristicSerializer>
@end
@implementation RZBCharacteristicSerializerUInt16

- (NSNumber *)objectWithCharacteristicData:(NSData *)data error:(NSError **)error
{
    uint16_t value = 0;
    [data getBytes:&value length:sizeof(uint16_t)];
    return [NSNumber numberWithInt:value];
}

- (NSData *)characteristicDataForObject:(id)object error:(NSError **)error
{
    uint16_t value = [object unsignedIntValue];
    return [NSData dataWithBytes:&value length:sizeof(uint16_t)];
}

@end

@interface RZBCharacteristicSerializerUTFString : NSObject <RZBCharacteristicSerializer>
@end
@implementation RZBCharacteristicSerializerUTFString

- (NSString *)objectWithCharacteristicData:(NSData *)data error:(NSError **)error
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)characteristicDataForObject:(NSString *)object error:(NSError **)error
{
    return [object dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation RZBCharacteristicSerializer

+ (id<RZBCharacteristicSerializer>)uInt8Serializer
{
    return [[RZBCharacteristicSerializerUInt8 alloc] init];
}

+ (id<RZBCharacteristicSerializer>)uInt16Serializer
{
    return [[RZBCharacteristicSerializerUInt16 alloc] init];
}

+ (id<RZBCharacteristicSerializer>)utfStringSerializer
{
    return [[RZBCharacteristicSerializerUTFString alloc] init];
}

@end
