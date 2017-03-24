//
//  MessageRoomDummyObject.h
//  WakeUp
//
//  Created by World on 7/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageRoomDummyObject : NSObject

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderId;
@property (nonatomic, strong) NSString *receiverId;
@property (nonatomic, strong) NSDate *sentOn;
@property (nonatomic, strong) ASIHTTPRequest *sendMessageRequest;

@end
