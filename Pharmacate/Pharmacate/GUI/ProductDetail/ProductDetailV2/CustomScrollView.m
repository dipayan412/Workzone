//
//  CustomScrollView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] )
    {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
