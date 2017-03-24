//
//  SearchResultObject.h
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultObject : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *userPhotoId;
@property (nonatomic, strong) NSString *userPhone;

@end
