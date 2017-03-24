//
//  ShopObject.h
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopObject : NSObject

@property (nonatomic, retain) NSString *registeredOn;
@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *shopBeaconId;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

@end
