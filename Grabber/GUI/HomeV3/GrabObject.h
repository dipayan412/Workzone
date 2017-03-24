//
//  GrabObject.h
//  Grabber
//
//  Created by World on 4/15/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrabObject : NSObject

@property (nonatomic, strong) NSString *grabId;
@property (nonatomic, strong) NSString *grabDescription;
@property (nonatomic, strong) NSString *grabOwnerFbId;
@property (nonatomic, strong) NSString *grabOwnerFbFullName;
@property (nonatomic, assign) float grabLat;
@property (nonatomic, assign) float grabLong;
@property (nonatomic, strong) UIImage *grabImage;
@property (nonatomic, strong) NSString *grabOwnerUsername;
@property (nonatomic, strong) NSDate *grabCreatedDate;
@property (nonatomic, strong) NSString *grabLoaction;

@end
