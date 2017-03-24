//
//  PersonObject.h
//  Grabber
//
//  Created by World on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonObject : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImage *proPic;

@end
