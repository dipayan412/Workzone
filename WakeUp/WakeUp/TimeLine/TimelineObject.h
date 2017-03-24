//
//  TimelineObject.h
//  WakeUp
//
//  Created by World on 6/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineObject : NSObject

@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postHeader;
@property (nonatomic, strong) NSString *postStatus;
@property (nonatomic, strong) NSString *postPhotoId;
@property (nonatomic, strong) NSString *postUserId;
@property (nonatomic, strong) NSString *postUserPhotoId;
@property (nonatomic, strong) UIImage *postPhoto;
@property (nonatomic, strong) UIImage *postUserPhoto;

@end
