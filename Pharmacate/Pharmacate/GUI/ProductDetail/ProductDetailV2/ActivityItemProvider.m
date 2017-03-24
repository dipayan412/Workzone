//
//  ActivityItemProvider.m
//  Pharmacate
//
//  Created by Dipayan Banik on 9/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ActivityItemProvider.h"

@implementation ActivityItemProvider
@synthesize activityController;
@synthesize imageLink;


- (id)item
{
    // Return nil, if you don't want this provider to apply
    // to a particular activity type (say, if you provide
    // print data as a separate item for UIActivityViewController).
    if ([self.activityType isEqualToString:UIActivityTypePostToFacebook])
    {
        NSLog(@"ffffffff");
        return nil;
    }
    
    
    // The data you passed while initialising your provider
    // is in placeholderItem now.
    if ([self.activityType isEqualToString:UIActivityTypeMail] ||
        [self.activityType isEqualToString:UIActivityTypeCopyToPasteboard])
    {
        return self.placeholderItem;
    }
    
    // Return something else for other activities. Obviously,
    // you can as well reuse the data in placeholderItem here.
    return @"Something else";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSLog(@"%@", activityType);
    if([activityType isEqualToString:UIActivityTypePostToFacebook])
    {
        [activityController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookShare" object:nil userInfo:nil];
    }
    return nil;
}

@end
