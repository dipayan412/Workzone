//
//  ShareViewController.m
//  SocialShare
//
//  Created by Ashif on 2/17/14.
//  Copyright (c) 2014 algonyx. All rights reserved.
//

#import "ShareViewController.h"
#import "YoutubeActivity.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    
    self.title = @"Share Video";
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)shareToSocialNetworks:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YouTubeTest" ofType:@"m4v"];
    NSURL *urlToVideoFile = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
    NSLog(@"urlToVideoFile %@", urlToVideoFile);
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"Share Text, (any added message),\n\nhttp://www.facebook.com"],urlToVideoFile];
    
    YoutubeActivity *youtubeActivity = [[YoutubeActivity alloc] init];
    // Create the activity view controller passing in the activity provider, image and url we want to share along with the additional source we want to appear (google+)

    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:@[youtubeActivity]];
    [activityViewController setValue:@"Your email Subject" forKey:@"subject"];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToTencentWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        NSLog(@"activityType %@, completed %d", activityType, completed);
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if([activityType isEqualToString:@"com.mobilica.youtubesharing"])
        {
            YoutubeLoginViewController *loginVC = [[YoutubeLoginViewController alloc] initWithNibName:@"YoutubeLoginViewController" bundle:nil];
            loginVC.delegate = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self.navigationController presentViewController:navController animated:YES completion:nil];
        }
    };
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)dismissYoutubeShareView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
