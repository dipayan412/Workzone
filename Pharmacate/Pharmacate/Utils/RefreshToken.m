//
//  RefreshToken.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "RefreshToken.h"

@implementation RefreshToken
{
    NSTimer *refreshTimer;
}

static RefreshToken *sharedInstance = nil;

+(id)sharedInstance
{
    @synchronized ([RefreshToken class])
    {
        if(!sharedInstance)
        {
            sharedInstance = [[RefreshToken alloc] init];
        }
    }
    return sharedInstance;
}

-(void)startTimer
{
    [self getNewToken];
    [self stopTimer];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1500
                                                 target:self
                                               selector:@selector(getNewToken)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)stopTimer
{
    [refreshTimer invalidate];
    refreshTimer = nil;
}

-(void)getNewToken
{
    if(![[UserDefaultsManager getUserToken] isEqualToString:@""])
    {
        NSLog(@"refreshing token");
        NSURL *URL = [NSURL URLWithString:refreshToken];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        //    request.timeoutInterval = 10;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        NSError *error;
        NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaultsManager getUserId], @"USR_ID", nil];
        
        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *dataJSON;
            if(data)
            {
                dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            }
            else
            {
                
            }
            NSLog(@"refreshToken %@",dataJSON);
            if(!error)
            {
                if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
                {
                    if([dataJSON objectForKey:@"TOKEN"] != [NSNull null] && [dataJSON objectForKey:@"TOKEN"])
                    {
                        [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                    }
                    else
                    {
                        
                    }
                }
                else
                {
                    
                }
            }
            else
            {
                NSLog(@"%@",error);
            }
            
        }];
        [dataTask resume];
    }
}


@end
