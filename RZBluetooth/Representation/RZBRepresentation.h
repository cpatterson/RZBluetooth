//
//  RZBRepresentation.h
//  RZBluetooth
//
//  Created by Brian King on 8/8/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

@protocol RZBCharacteristicSerializer;

@protocol RZBServiceRepresentation <NSObject>

- (CBUUID *)serviceUUID;
- (Class)class;
- (NSDictionary *)characteristicUUIDsByKey;
- (CBCharacteristicProperties)characteristicPropertiesForKey:(NSString *)key;
- (id<RZBCharacteristicSerializer>)serializerForKey:(NSString *)key;

@end

@protocol RZBServiceRepresentable <NSObject>

+ (id<RZBServiceRepresentation>)serviceRepresentation;

// Add NSObject KVC selectors, since the protocol doesn't have them.
- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

@end