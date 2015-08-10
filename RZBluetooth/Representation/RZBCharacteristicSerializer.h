//
//  RZBCharacteristicSerializer.h
//  RZBluetooth
//
//  Created by Brian King on 8/8/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZBCharacteristicSerializer <NSObject>

- (id)objectWithCharacteristicData:(NSData *)data error:(NSError **)error;
- (NSData *)characteristicDataForObject:(id)object error:(NSError **)error;

@end


@interface RZBCharacteristicSerializer : NSObject

+ (id<RZBCharacteristicSerializer>)uInt8Serializer;
+ (id<RZBCharacteristicSerializer>)uInt16Serializer;
+ (id<RZBCharacteristicSerializer>)utfStringSerializer;

@end
