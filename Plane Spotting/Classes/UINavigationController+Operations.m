//
//  UINavigationController+Operations.m
//  TravelCamera
//
//  Created by shabib hossain on 5/23/13.
//
//

#import "UINavigationController+Operations.h"

@implementation UINavigationController (Operations)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//    return UIInterfaceOrientationMaskPortrait;
}
*/

@end
