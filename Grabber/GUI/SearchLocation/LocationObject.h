//
//  LocationObject.h
//  Grabber
//
//  Created by World on 3/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationObject : NSObject

@property (nonatomic, retain) NSString *locationIconUrl;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSString *locationAddress;
@property (nonatomic, retain) NSData *locationIconData;
@property (nonatomic, assign) float locationLatitude;
@property (nonatomic, assign) float locationLongitude;

@end
