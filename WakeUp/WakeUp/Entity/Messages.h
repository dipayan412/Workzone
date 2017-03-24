//
//  Messages.h
//  WakeUp
//
//  Created by World on 7/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * receiverId;
@property (nonatomic, retain) NSString * senderId;
@property (nonatomic, retain) NSDate * sentOn;
@property (nonatomic, retain) NSString * senderName;

@end
