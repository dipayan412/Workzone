//
//  MyPointsViewController.m
//  Grabber
//
//  Created by World on 4/12/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MyPointsViewController.h"

@interface MyPointsViewController () <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *getMyPointsRequest;
}

@end

@implementation MyPointsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",getMyRewardPointsApi];
    [urlStr appendFormat:@"%@",[UserDefaultsManager sessionToken]];
    
    getMyPointsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    getMyPointsRequest.delegate = self;
    [getMyPointsRequest startAsynchronous];
    
    pointsLabel.text = @"Your total point is ";
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
//    NSError *error = nil;
//    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"myPointsResponse: %@",request.responseString);
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
