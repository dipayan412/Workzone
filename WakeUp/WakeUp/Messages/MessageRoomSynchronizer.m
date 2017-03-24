//
//  InboxSynchronizer.m
//  WakeUp
//
//  Created by World on 7/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MessageRoomSynchronizer.h"
#import "AppDelegate.h"
#import "Messages.h"

#define kTimerInterval 30.0f

@interface MessageRoomSynchronizer()

@property (nonatomic, strong) MessageRoom *partnerRoom;

@end

@implementation MessageRoomSynchronizer
{
    ASIHTTPRequest *syncMessageRoomRequest;
    NSTimer *syncInboxTimer;
}

@synthesize partnerRoom;

static MessageRoomSynchronizer *instance = nil;

+(MessageRoomSynchronizer*)getInstance
{
    if(instance == nil)
    {
        instance = [[MessageRoomSynchronizer alloc] init];
    }
    return instance;
}

-(void)startSynchronizer:(MessageRoom*)_partnerRoom
{
    self.partnerRoom = _partnerRoom;
    if (!started)
    {
        started = YES;
        [self synchronize];
    }
}

-(void)synchronize
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageRoomSyncStartedNotification object:nil];
    
    if (!running)
    {
        if (started && scheduler)
        {
            [scheduler invalidate];
        }
        
        [self startLoadingData];
    }
}

-(void)synchronizeOnce:(MessageRoom*)_partnerRoom
{
    self.partnerRoom = _partnerRoom;
    [self synchronize];
}

-(void)stopSynchronizer
{
    if (started && scheduler)
    {
        [scheduler invalidate];
    }
    
    started = NO;
}

-(void)startLoadingData
{
    NSLog(@"in room sync\n");
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@", kBaseUrl];
    [urlStr appendFormat:@"cmd=%@", kSyncMessageRoomApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&pid=%@", self.partnerRoom.pid];
    [urlStr appendFormat:@"&sts=%ld", self.partnerRoom.syncTime.longValue];
    
    NSLog(@"syncRoomUrlStr %@",urlStr);
    
    syncMessageRoomRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    syncMessageRoomRequest.delegate = self;
    syncMessageRoomRequest.timeOutSeconds = 120;
    [syncMessageRoomRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"syncRoomRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        NSError *error = nil;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
        
        NSDictionary *body = [responseObject objectForKey:@"body"];
        NSArray *inboxArray = [body objectForKey:@"messages"];
        
        BOOL updated = NO;
        
        for(int i = 0; i < inboxArray.count; i++)
        {
            NSDictionary *tmpDic = [inboxArray objectAtIndex:i];
            NSString *mid = [tmpDic objectForKey:@"mid"];
            
            Messages *msg = nil;
            
            NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:chartEntity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageId LIKE[c] %@",mid];
            [fetchRequest setPredicate:predicate];
            NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
            
            if (fetchedResult && fetchedResult.count > 0)
            {
                msg = [fetchedResult objectAtIndex:0];
            }
            
            if (msg == nil)
            {
                msg = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:context];
                
                msg.messageId = [tmpDic objectForKey:@"mid"];
                msg.senderId = [tmpDic objectForKey:@"sid"];
                msg.receiverId = [tmpDic objectForKey:@"rid"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
                
                msg.sentOn = [formatter dateFromString:[tmpDic objectForKey:@"dtime"]];
                
                msg.message = [tmpDic objectForKey:@"message"];
                msg.senderName = [tmpDic objectForKey:@"sname"];
                
                updated = YES;
            }
        }
        
        self.partnerRoom.syncTime = [NSNumber numberWithLong:[[body objectForKey:@"cstime"] longValue]];
        [context save:&error];
        
        if (updated)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMessageRoomSynchronizedNotification object:nil];
        }
    }
    
    running = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageRoomSyncSucceededNotification object:nil];
    
    if (started)
    {
        scheduler = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(synchronize) userInfo:nil repeats:NO];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageRoomSyncFailedNotification object:nil];
    running = NO;
    
    if (started)
    {
        scheduler = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(synchronize) userInfo:nil repeats:NO];
    }
}

@end
