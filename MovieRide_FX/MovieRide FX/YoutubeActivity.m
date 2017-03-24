//
//  YoutubeActivity.m
//  SocialShare
//
//  Created by Ashif on 2/19/14.
//  Copyright (c) 2014 algonyx. All rights reserved.
//

#import "YoutubeActivity.h"

@interface YoutubeActivity()

@property(nonatomic, strong) NSString *shareText;
@property(nonatomic, strong) NSURL *shareUrl;

@end

@implementation YoutubeActivity

@synthesize shareText;
@synthesize shareUrl;

// Return the name that should be displayed below the icon in the sharing menu
- (NSString *)activityTitle
{
    return @"Youtube";
}

// Return the string that uniquely identifies this activity type
- (NSString *)activityType
{
    return @"com.mobilica.youtubesharing";
}

// Return the image that will be displayed  as an icon in the sharing menu
- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"youtube.png"];
}

// allow this activity to be performed with any activity items
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    // Loop through all activity items and pull out the two we are looking for
    for (NSObject *item in activityItems)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            self.shareText = (NSString *) item;
        }
        else if ([item isKindOfClass:[NSURL class]])
        {
            self.shareUrl = (NSURL *) item;
        }
    }
}

// initiate the sharing process. First we will need to login
- (void)performActivity
{
    [self activityDidFinish:YES];
}

@end
