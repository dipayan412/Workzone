//
//  InboxObject.h
//  WakeUp
//
//  Created by World on 7/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxObject : NSObject

@property (nonatomic, strong) NSDate *inboxDate;
@property (nonatomic, strong) NSString *inboxSender;
@property (nonatomic, strong) NSString *inboxMessage;
@property (nonatomic, strong) NSString *inboxSenderId;

@end
