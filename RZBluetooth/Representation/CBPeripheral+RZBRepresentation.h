//
//  CBPeripheral+RZBRepresentation.h
//  RZBluetooth
//
//  Created by Brian King on 8/8/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "RZBDefines.h"
#import "RZBRepresentation.h"
#import "RZBCharacteristicSerializer.h"


typedef void(^RZBRepresentationBlock)(id object, NSError *error);

@interface CBPeripheral (RZBRepresentation)

- (void)rzb_fetchRepresentation:(id<RZBServiceRepresentation>)representation
                           keys:(NSArray *)keys
                     completion:(RZBRepresentationBlock)completion;

@end
