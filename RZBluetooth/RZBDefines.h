//
//  RZBDefines.h
//  UMTSDK
//
//  Created by Brian King on 7/30/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

@import CoreBluetooth;

typedef void(^RZBScanBlock)(CBPeripheral *peripheral, NSDictionary *advInfo, NSNumber *RSSI);
typedef void(^RZBErrorBlock)(NSError *error);

typedef void(^RZBPeripheralBlock)(CBPeripheral *peripheral, NSError *error);
typedef void(^RZBServiceBlock)(CBService *service, NSError *error);
typedef void(^RZBCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);

typedef void(^RZBRepresentationBlock)(id object, NSError *error);
