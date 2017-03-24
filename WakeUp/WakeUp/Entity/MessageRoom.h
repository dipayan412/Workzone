//
//  MessageRoom.h
//  WakeUp
//
//  Created by Ashif on 8/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageRoom : NSManagedObject

@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSString * lastMsgText;
@property (nonatomic, retain) NSString * pid;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSNumber * syncTime;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * partnerPhotoId;

@end
