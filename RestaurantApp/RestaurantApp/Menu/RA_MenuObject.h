//
//  RA_MenuObject.h
//  RestaurantApp
//
//  Created by World on 12/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RA_MenuObject : NSObject <NSCoding>

@property (nonatomic, retain) NSString *menuId;
@property (nonatomic, retain) NSString *menuName;
@property (nonatomic, retain) NSString *menuPrice;
@property (nonatomic, retain) NSString *menuImagePath;
@property (nonatomic, retain) NSString *menuDetails;
@property (nonatomic, retain) NSString *menuServeFor;
@property (nonatomic, assign) int numberOfOrder;

@end
