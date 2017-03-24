//
//  RA_MessageBoard.h
//  RestaurantApp
//
//  Created by shabib hossain on 2/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSSNS/AWSSNS.h>

@interface RA_MessageBoard : NSObject
{
    AmazonSNSClient *snsClient;
    
    NSString        *endpointARN;
}

+(RA_MessageBoard *)instance;

-(BOOL)createApplicationEndpoint;

@end
