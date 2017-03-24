//
//  NotificationScanner.m
//  WakeUp
//
//  Created by World on 6/26/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "NotificationScanner.h"

#define kTimerInterval 3000.0f

@interface NotificationScanner() <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *notificationRequest;
    NSTimer *notificationUpdateTimer;
    
}
//@property (nonatomic, strong)

@end

@implementation NotificationScanner
{
    
}
//@synthesize notificationUpdateTimer;

static NotificationScanner *instance = nil;

//static NSTimer *notificationUpdateTimer = nil;

+(NotificationScanner*)getInstance
{
    if(instance == nil)
    {
        instance = [[NotificationScanner alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(void)startNotificationScanner
{
    if(notificationUpdateTimer == nil)
    {
        notificationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(notificationTimerTikked) userInfo:nil repeats:YES];
    }
}

-(void)notificationTimerTikked
{
    NSLog(@"in scanner\n");
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@&",kNotificationApi];
    [urlStr appendFormat:@"phone=%@",[UserDefaultsManager userPhoneNumber]];
    
    NSLog(@"notificationUrlStr %@",urlStr);
    
    notificationRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    notificationRequest.delegate = self;
    [notificationRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"notificationRequest return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
    if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
    {
        NSInteger count = [[[responseObject objectForKey:@"body"] objectForKey:@"notifications"] count];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)count], kNotificationArrivalTotalKey, nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationArrival object:nil userInfo:userInfo];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
}

@end
