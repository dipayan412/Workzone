//
//  InAppHelperClass.m
//  PhotoPuzzle
//
//  Created by World on 10/30/13.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "InAppHelperClass.h"

#import "AppDelegate.h"
#import "SettingPage.h"
#import "mainview.h"
#import "photoView.h"
#import "MBProgressHUD.h"
#import "InAppRageIAPHelper.h"
#import "Reachability.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "photoView.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "Flurry.h"
#import "Neocortex.h"


#import "UserDefaultsManager.h"

static InAppHelperClass *inApp = nil;

@implementation InAppHelperClass

@synthesize hud;
@synthesize Email;

+(id)getInstance
{
    if(inApp == nil)
    {
        inApp = [[InAppHelperClass alloc] init];
    }
    return inApp;
}

-(void)triggerInApp
{
    tagId = 0;
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    SKProduct *product=Nil;
    if (product!=Nil)
    {
        [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    }
    else
    {
        //      NSLog(@"Buying %@...", [[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]);
        [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    self.hud = [[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow] autorelease];
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];
    [window addSubview:self.hud];
    self.hud.labelText = @"Loading...";//[NSString stringWithFormat:@"%@",[[storename objectAtIndex:tagId] objectForKey:@"Name"]];
    [self.hud show:YES];
}

- (void)dismissHUD:(id)arg
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.hud removeFromSuperview];
    self.hud = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        appDelegate.TopAd=NO;
    }
    else
    {
        appDelegate.TopAd=YES;
    }
    if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        appDelegate.bottomAd=NO;
    }
    else
    {
        appDelegate.bottomAd=YES;
    }
    
}

- (void)productsLoaded:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)timeout:(id)arg
{
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]] autorelease];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}



- (void)productPurchased:(NSNotification *)notification
{
    NSLog(@"Purchased!!!");
    
    
    [UserDefaultsManager setProUpgradePurchaseDone:YES];
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *productIdentifier = (NSString *) notification.object;
        NSLog(@"Purchased: %@", productIdentifier);
        NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",tagId],@"tag",@"Yes",@"ButtonState",nil] autorelease];
        NSLog(@"%@",newDict);
        NSLog(@"%@",storename);
        [storename replaceObjectAtIndex:tagId withObject:newDict];
        [self updateData];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            appDelegate.TopAd=NO;
        }
        else
        {
            appDelegate.TopAd=YES;
        }
        if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            appDelegate.bottomAd=NO;
        }
        else
        {
            appDelegate.bottomAd=YES;
        }
        if(appDelegate.TopAd==YES)
        {
            [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
            [Flurry logEvent:@"Top Ads Purchased" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME],@"From", nil]];
        }
        if(appDelegate.bottomAd==YES)
        {
            [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
            [Flurry logEvent:@"Bottom Ads Purchased" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME],@"From", nil]];
        }
    }
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {
        
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.hud removeFromSuperview];
        
        if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeTopSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=NO;
        }
        else
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=YES;
        }
        if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeBottomSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.bottomAd=NO;
        }
        else
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.bottomAd=YES;
        }
        
        SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
        if (transaction.error.code != SKErrorPaymentCancelled) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                             message:transaction.error.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil] autorelease];
            
            [alert show];
        }
        
    }
    
}
-(void)loadData
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists)
    {
        
        storename = [[NSMutableArray alloc] initWithContentsOfFile:filepath];
    }
    else
    {
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"];

        storename = [[NSMutableArray alloc] initWithContentsOfFile:filePath1];
    }
}
-(void)updateData
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists)
    {
        [storename writeToFile:filepath atomically:YES];
    }
    else
    {
        [storename writeToFile:filepath atomically:YES];
    }
    NSLog(@"filepath  %@",filepath);
}

@end
