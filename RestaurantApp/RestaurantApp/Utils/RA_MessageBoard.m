//
//  RA_MessageBoard.m
//  RestaurantApp
//
//  Created by shabib hossain on 2/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <AWSRuntime/AWSRuntime.h>
#import "RA_MessageBoard.h"

@implementation RA_MessageBoard

static RA_MessageBoard *_instance = nil;

+(RA_MessageBoard *)instance
{
    if (!_instance)
    {
        @synchronized([RA_MessageBoard class])
        {
            if (!_instance)
            {
                _instance = [self new];
            }
        }
    }
    
    return _instance;
}

-(id)init
{
    if (self = [super init])
    {
        snsClient = [[AmazonSNSClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        snsClient.endpoint = [AmazonEndpoints snsEndpoint:US_EAST_1];
        
        // Find endpointARN for this device if there is one.
        endpointARN = [self findEndpointARN];
    }
    
    return self;
}

-(BOOL)createApplicationEndpoint
{
    NSString *deviceToken = [RA_UserDefaultsManager deviceToken];
    
    if (!deviceToken)
    {
        NSLog(@"deviceToken not found! Device may fail to register with Apple's Notification Service, please check debug window for details");
    }
    
    SNSCreatePlatformEndpointRequest *endpointReq = [[SNSCreatePlatformEndpointRequest alloc] init];
    endpointReq.platformApplicationArn = PLATFORM_APPLICATION_ARN;
    endpointReq.token = deviceToken;
    
    @try {
        SNSCreatePlatformEndpointResponse *endpointResponse = [snsClient createPlatformEndpoint:endpointReq];
        
        if (endpointResponse.error != nil)
        {
            NSLog(@"Error: %@", endpointResponse.error);
            return NO;
        }
        
        endpointARN = endpointResponse.endpointArn;
        
        [RA_UserDefaultsManager setDeviceEndPoint:endpointResponse.endpointArn];
    }
    @catch (SNSInvalidParameterException *exception) {
        NSLog(@"%@", exception.debugDescription);
    }
    
    return YES;
}

-(NSString *)findEndpointARN
{
    return (endpointARN != nil) ? endpointARN : [RA_UserDefaultsManager deviceEndPoint];
}

@end
