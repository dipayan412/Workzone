//
//  RA_ShareManager.m
//  RestaurantApp
//
//  Created by Ashif on 2/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RA_ShareManager.h"
#import "RA_MenuObject.h"
#import "RA_AppDelegate.h"
#import <Social/Social.h>

@implementation RA_ShareManager

/**
 * Method name: shareToPlatfrom
 * Description: share the menu object accroding to the platform
 * Parameters: action name, the menu object which to be shared, image of the item, the view controller from where the share is called
 */

+(void)shareToPlatfrom:(kSettingsOptions)_platform object:(RA_MenuObject*)_obj menuImage:(UIImage*)_image fromController:(UIViewController*)_controller
{
    RA_MenuObject *menuObject = [[RA_MenuObject alloc] init];
    menuObject = _obj;
    
    RA_AppDelegate *apdl = (RA_AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(_platform == kFacebook)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {   
            SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
            //            [composeVC addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
            if(_image)
            {
                [composeVC addImage:_image];
            }
            
            [composeVC setInitialText:[NSString stringWithFormat:@"%@\n%@: %@ %@\n%@", menuObject.menuName, AMLocalizedString(@"kPrice", nil),menuObject.menuPrice,apdl.currency, menuObject.menuDetails]];

            if(composeVC)
            {
                
                // assume everything validates
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
                {
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        NSLog(@"Cancelled");
                        
                    }
                    else
                    {
                        NSLog(@"Post");
                    }
                    
                    [composeVC dismissViewControllerAnimated:YES completion:Nil];
                };
                
                composeVC.completionHandler = myBlock;
                [_controller presentViewController: composeVC animated: YES completion: nil];
            }
        }
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        controller.view.hidden = YES;
        [_controller presentViewController:controller animated:NO completion:nil];
    }
    else
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
            if(_image)
            {
                [composeVC addImage:_image];
            }
            
            [composeVC setInitialText:[NSString stringWithFormat:@"%@\n%@: %@ %@\n%@", menuObject.menuName, AMLocalizedString(@"kPrice", nil),menuObject.menuPrice,apdl.currency, menuObject.menuDetails]];
            
            if(composeVC)
            {
                // assume everything validates
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
                {
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        NSLog(@"Cancelled");
                        
                    }
                    else
                    {
                        NSLog(@"Post");
                    }
                    
                    [composeVC dismissViewControllerAnimated:YES completion:Nil];
                };
                
                composeVC.completionHandler = myBlock;
                [_controller presentViewController: composeVC animated: YES completion: nil];
            }
        }
        else
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            controller.view.hidden = YES;
            [_controller presentViewController:controller animated:NO completion:nil];
        }
    }
}

@end
