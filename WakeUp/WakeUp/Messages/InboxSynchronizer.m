//
//  InboxSynchronizer.m
//  WakeUp
//
//  Created by World on 7/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "InboxSynchronizer.h"
#import "AppDelegate.h"
#import "MessageRoom.h"
#import "MessageRoomSynchronizer.h"

#define kTimerInterval 60.0f

@implementation InboxSynchronizer
{
    ASIHTTPRequest *syncInboxRequest;
    NSTimer *syncInboxTimer;
}

static InboxSynchronizer *instance = nil;

+(InboxSynchronizer*)getInstance
{
    if(instance == nil)
    {
        instance = [[InboxSynchronizer alloc] init];
    }
    return instance;
}

-(void)startSynchronizer
{
    if (!started)
    {
        started = YES;
        [self synchronizeOnce];
    }
}

-(void)synchronizeOnce
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInboxSyncStartedNotification object:nil];
    
    if (!running)
    {
        if (started && scheduler)
        {
            [scheduler invalidate];
        }
        
        [self startLoadingData];
    }
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
    NSLog(@"in inbox sync\n");
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kSyncInboxApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&sts=%@",[UserDefaultsManager cSTime]];
    
    NSLog(@"syncInboxUrlStr %@",urlStr);
    
    syncInboxRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    syncInboxRequest.delegate = self;
    syncInboxRequest.timeOutSeconds = 120;
    [syncInboxRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"inboxRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        NSError *error = nil;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
        
        NSDictionary *body = [responseObject objectForKey:@"body"];
        NSArray *inboxArray = [body objectForKey:@"inbox"];
        
        BOOL updated = NO;
        
        for(int i = 0; i < inboxArray.count; i++)
        {
            NSDictionary *tmpDic = [inboxArray objectAtIndex:i];
            NSString *pid = [tmpDic objectForKey:@"pid"];
            
            MessageRoom *mRoom = nil;
            
            NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"MessageRoom" inManagedObjectContext:context];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:chartEntity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.pid = %@",pid];
            [fetchRequest setPredicate:predicate];
            NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
            
            if (fetchedResult && fetchedResult.count > 0)
            {
                mRoom = [fetchedResult objectAtIndex:0];
            }
            
            if (mRoom == nil)
            {
                mRoom = [NSEntityDescription insertNewObjectForEntityForName:@"MessageRoom" inManagedObjectContext:context];
                mRoom.pid = pid;
                mRoom.syncTime = [NSNumber numberWithLong:0L];
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
            
            mRoom.time = [formatter dateFromString:[tmpDic objectForKey:@"dtime"]];
            mRoom.senderName = [tmpDic objectForKey:@"header"];
            mRoom.lastMsgText = [tmpDic objectForKey:@"message"];
            NSString *uphotoId = [NSString stringWithFormat:@"%@", [tmpDic objectForKey:@"uphoto"]];
            if(uphotoId && uphotoId.length > 0)
            {
                mRoom.partnerPhotoId = uphotoId;
            }
            
            updated = YES;
            
            [[MessageRoomSynchronizer getInstance] synchronizeOnce:mRoom];
        }
        
        [context save:&error];
        [UserDefaultsManager setCSTime:[body objectForKey:@"cstime"]];
        
        if (updated)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kInboxSynchronizedNotification object:nil];
        }
    }
    
    running = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kInboxSyncSucceededNotification object:nil];
    
    if (started)
    {
        scheduler = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(synchronizeOnce) userInfo:nil repeats:NO];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInboxSyncFailedNotification object:nil];
    running = NO;
    
    if (started)
    {
        scheduler = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(synchronizeOnce) userInfo:nil repeats:NO];
    }
}

@end
