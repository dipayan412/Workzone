//
//  SettingPage.m
//  PhotoPuzzle
//
//  Created by muhammad sami ather on 6/11/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//
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
#import "UserDefaultsManager.h"

@interface SettingPage ()
{
    UIButton *suspend;
}

@end

@implementation SettingPage
@synthesize tabBar;
@synthesize moreButton;
@synthesize bottomAds;
@synthesize topAds;
@synthesize sound;
@synthesize hud;
@synthesize Email;
@synthesize soundSwitch,topAdSwitch,bottomAdSwitch;
@synthesize customizedTabBar;
//@synthesize adBannerViewIsVisible=_adBannerViewIsVisible;
//@synthesize 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[singletonClass sharedsingletonClass].pool drain];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - PlayHaven
-(void)loadPlayHaven
{
    PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:PLAYHAVEN_APP_TOKEN secret:PLAYHAVEN_APP_SECRET placement:@"main_menu" delegate:self];
    [request setShowsOverlayImmediately:true];
    [request setAnimated:true];
    [request send];
}
#pragma mark - Playhaven PHPublisherdelegate
-(void)requestDidGetContent:(PHPublisherContentRequest *)request
{
    NSLog(@"requestDidGetContent");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content
{
    NSLog(@"contentDidDisplay");
}
-(void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type
{
    NSLog(@"contentDidDismissWithType");
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    proUpgradeAlert = [[UIAlertView alloc] initWithTitle:@"Upgrade To Pro" message:@"Upgrade to Pro for just $2.99 to enjoy full access and No ads." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    
    if([UserDefaultsManager isProUpgradePurchaseDone])
    {
        [self changeUIForPro];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"soundIsOff"])
    {
        self.soundIsOn = NO;
        [self.soundSwitch setFrame:CGRectMake(115, self.soundSwitch.frame.origin.y, self.soundSwitch.frame.size.width, self.soundSwitch.frame.size.height)];
    }
    else
    {
        self.soundIsOn = YES;
        [self.soundSwitch setFrame:CGRectMake(147, self.soundSwitch.frame.origin.y, self.soundSwitch.frame.size.width, self.soundSwitch.frame.size.height)];
       
    }
    if([[[ALSharedData getSharedInstance] playHavenInfoObj] showOnPauseMenu] == YES)
    {
        [self loadPlayHaven];
    }
    if([[[ALSharedData getSharedInstance] appLovinInfoObj] showOnPauseMenu] == YES)
    {
        [ALInterstitialAd showOver:[(AppDelegate*)[[UIApplication sharedApplication] delegate] window]];
    }
    
    
    
    [self loadData];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    

    
    self.customizedTabBar = [nibObjects objectAtIndex:0];
    self.customizedTabBar.frame = CGRectMake(0, self.view.bounds.size.height - customizedTabBar.frame.size.height , customizedTabBar.frame.size.width, 50);
    [self.view addSubview:customizedTabBar];
    //    self.customizedTabBar
    [self.customizedTabBar selectTab:11];
    self.customizedTabBar.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.hidesBackButton=YES;
    
    if (![UserDefaultsManager isProUpgradePurchaseDone])
    {
        //[[Neocortex getInstance] onLevelsMenu];
//        [[SNAdsManager sharedManager]  giveMeGameOverAd];
    }
    
    if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        [topAds setOn:NO];
    }
    else
    {
        [topAds setOn:YES];
    }
    if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        [bottomAds setOn:NO];
    }
    else
    {
        [bottomAds setOn:YES]; 
    }
    // Do any additional setup after loading the view from its nib.
   // self.title=@"Setting Page";
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"optionsbar.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
    rightview.backgroundColor=[UIColor clearColor];
    suspend=[[UIButton alloc]initWithFrame:CGRectMake(0,3, 40, 40)];
    
    // suspend.layer.cornerRadius=20.0;
    suspend.clipsToBounds=YES;
    
    suspend.contentMode=UIViewContentModeScaleAspectFit;
    [suspend setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [suspend addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [rightview addSubview:suspend];
//    [suspend release];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.leftBarButtonItem = customItem;
    [customItem release];
    [rightview release];
    tabBar.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [sound setOn:YES];
    }
    else
        [sound setOn:NO];
    [self.view bringSubviewToFront:moreButton];
}

#pragma mark tabbar function
-(void)tabWasSelected:(NSInteger)index
{
    if(index==12)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        
    }
  
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_option.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    [self.view addSubview:suspend];
  
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.TopAd==NO)
    {
        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
        CGRect newFrame ;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
        newFrame.origin.y=0.0f;
        newFrame.size.height=50.0f;
        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
    }
    else
    {
        [self.topAdSwitch setFrame:CGRectMake(202, self.topAdSwitch.frame.origin.y, self.topAdSwitch.frame.size.width, self.topAdSwitch.frame.size.height)];
    }
    if(appDelegate.bottomAd==NO)
    {
        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
        CGRect newFrame ;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=322.0f;
        newFrame.origin.y= self.view.bounds.size.height - 100;
        newFrame.size.height=50.0f;
        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
    }
    else
    {
        [self.bottomAdSwitch setFrame:CGRectMake(202, self.bottomAdSwitch.frame.origin.y, self.bottomAdSwitch.frame.size.width, self.bottomAdSwitch.frame.size.height)];
    }
    if(appDelegate.bottomAd==YES)
    {
        [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 330, moreButton.frame.size.width, moreButton.frame.size.height)];
    }
    tabBar.selectedItem=[[self.tabBar items]objectAtIndex:0];
}
-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.TopAd==NO)
    {
        [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
    }
    if(appDelegate.bottomAd==NO)
    {
        [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
    }
}
- (void)viewDidUnload
{
    [self setSound:nil];
    [self setTopAds:nil];
    [self setBottomAds:nil];
    [self setMoreButton:nil];
    [self setTabBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [self.soundSwitch release];
    [self.topAdSwitch release];
    [self.bottomAdSwitch release];
    [self.customizedTabBar release];
    [tabBar release];
    [sound release];
    [topAds release];
    [bottomAds release];
    [moreButton release];
    [super dealloc];
}
#pragma mark - New IBActions
-(IBAction)soundButton:(id)sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(self.soundIsOn==NO)
    {
        appDelegate.sound=YES;
        self.soundIsOn = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        [self.soundSwitch setFrame:CGRectMake(147, self.soundSwitch.frame.origin.y, self.soundSwitch.frame.size.width, self.soundSwitch.frame.size.height)];
        [UIView commitAnimations];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"soundIsOff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    else
    {
        
        appDelegate.sound=NO;
        self.soundIsOn = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        [self.soundSwitch setFrame:CGRectMake(115, self.soundSwitch.frame.origin.y, self.soundSwitch.frame.size.width, self.soundSwitch.frame.size.height)];
        [UIView commitAnimations];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"soundIsOff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[singletonClass sharedsingletonClass].theAudios1 stop];
    }
}
-(IBAction)topAdButton:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeTopSwitch"])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self.topAdSwitch setFrame:CGRectMake(202, self.topAdSwitch.frame.origin.y, self.topAdSwitch.frame.size.width, self.topAdSwitch.frame.size.height)];
        [UIView commitAnimations];
        [Flurry logEvent:@"Remove Ads Switch" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"Remove Top Ads Switch",@"Name", nil]];
        [[NSUserDefaults standardUserDefaults] setObject:@"Remove Top Ads Switch" forKey:ALERT_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self topAdsSwitch:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTimeTopSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Already purchased." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}
-(IBAction)bottomAdButton:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeBottomSwitch"])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self.bottomAdSwitch setFrame:CGRectMake(202, self.bottomAdSwitch.frame.origin.y, self.bottomAdSwitch.frame.size.width, self.bottomAdSwitch.frame.size.height)];
        [UIView commitAnimations];
        [Flurry logEvent:@"Remove Ads Switch" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"Remove Bottom Ads Switch",@"Name", nil]];
        [[NSUserDefaults standardUserDefaults] setObject:@"Remove Bottom Ads Switch" forKey:ALERT_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self bottomAdsSwitch:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTimeBottomSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Already purchased." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == proUpgradeAlert)
    {
        if(buttonIndex == 1)
        {
            SKProduct *product=Nil;
            if (product!=Nil) {
                //    NSLog(@"Buying %@...", product.productIdentifier);
                [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
            }
            else{
                //      NSLog(@"Buying %@...", [[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]);
                [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]];
            }
            
            NSLog(@"------->>>>>>>%@",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]);
            
            //    NSLog(@"Show HUD - DatabaseIO");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            self.hud = [[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow] autorelease];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];
            [window addSubview:self.hud];
            self.hud.labelText = [NSString stringWithFormat:@"%@",[[storename objectAtIndex:tagId] objectForKey:@"Name"]];
            [self.hud show:YES];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeTopSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.topAdSwitch setFrame:CGRectMake(171, self.topAdSwitch.frame.origin.y, self.topAdSwitch.frame.size.width, self.topAdSwitch.frame.size.height)];
        }
    }
}

- (IBAction)topAdsSwitch:(id)sender {
    tagId=0;
    if([[[storename objectAtIndex:tagId] objectForKey:@"Purchased"] isEqualToString:@"Yes"])
    {
        if([[[storename objectAtIndex:tagId] objectForKey:@"ButtonState"] isEqualToString:@"Yes"])
        {
            NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",0],@"tag",@"No",@"ButtonState",nil] autorelease];
//            NSLog(@"%@",newDict);
//            NSLog(@"%@",storename);
            [storename replaceObjectAtIndex:tagId withObject:newDict];
            [self updateData];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=NO;
            if(appDelegate.TopAd==YES)
            {
                [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
            }
            else
            {
//                [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
            }
//            if(appDelegate.bottomAd==YES)
//            {
//                [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
//            }
//            else
//            {
//                [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
//            }
        }
        else
        {
            NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",tagId],@"tag",@"Yes",@"ButtonState",nil] autorelease];
//            NSLog(@"%@",newDict);
//            NSLog(@"%@",storename);
            [storename replaceObjectAtIndex:tagId withObject:newDict];
            [self updateData];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=YES;
            if(appDelegate.TopAd==YES)
            {
                [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
            }
            else
            {
                [singletonClass sharedsingletonClass].adWhrilView=[AdWhirlView requestAdWhirlViewWithDelegate:self];
//                [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
            }
        }
    }
    else
    {
        [proUpgradeAlert show];
//        SKProduct *product=Nil;
//        if (product!=Nil) {
//        //    NSLog(@"Buying %@...", product.productIdentifier);
//            [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
//        }
//        else{
//      //      NSLog(@"Buying %@...", [[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]);
//            [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]];
//        }
//        
//    //    NSLog(@"Show HUD - DatabaseIO");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        
//        
//        self.hud = [[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow] autorelease];
//        [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];
//        [window addSubview:self.hud];
//        self.hud.labelText = [NSString stringWithFormat:@"%@",[[storename objectAtIndex:tagId] objectForKey:@"Name"]];
//        [self.hud show:YES];
    }
}

- (IBAction)bottomAdsSwitch:(id)sender 
{
    tagId=1;
    if([[[storename objectAtIndex:tagId] objectForKey:@"Purchased"] isEqualToString:@"Yes"])
    {
        if([[[storename objectAtIndex:tagId] objectForKey:@"ButtonState"] isEqualToString:@"Yes"])
        {
            NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",0],@"tag",@"No",@"ButtonState",nil] autorelease];
//            NSLog(@"%@",newDict);
//            NSLog(@"%@",storename);
            [storename replaceObjectAtIndex:tagId withObject:newDict];
            [self updateData];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.bottomAd=NO;
            if(appDelegate.bottomAd==YES)
            {
                [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
                [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 330, moreButton.frame.size.width, moreButton.frame.size.height)];
            }
            else
            {
//                [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
                [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 290, moreButton.frame.size.width, moreButton.frame.size.height)];
            }
        }
        else
        {
            NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",tagId],@"tag",@"Yes",@"ButtonState",nil] autorelease];
            NSLog(@"%@",newDict);
            NSLog(@"%@",storename);
            [storename replaceObjectAtIndex:tagId withObject:newDict];
            [self updateData];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.bottomAd=YES;
            if(appDelegate.bottomAd==YES)
            {
                [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
                [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 330, moreButton.frame.size.width, moreButton.frame.size.height)];
            }
            else
            {
//                [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
                [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 290, moreButton.frame.size.width, moreButton.frame.size.height)];
            }
        }
    }
    else
    {
        [proUpgradeAlert show];
//        SKProduct *product=Nil;
//        if (product!=Nil) {
//         //   NSLog(@"Buying %@...", product.productIdentifier);
//            [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
//        }
//        else{
//       //     NSLog(@"Buying %@...", [[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]);
//            [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"]];
//        }
//        
//        NSLog(@"Show HUD - DatabaseIO");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        
//        
//        self.hud = [[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow] autorelease];
//        [self performSelector:@selector(timeout:) withObject:nil afterDelay:60];
//        [window addSubview:self.hud];
//        self.hud.labelText = [NSString stringWithFormat:@"%@",[[storename objectAtIndex:tagId] objectForKey:@"Name"]];
//        [self.hud show:YES];
    }
}
- (IBAction)soundSwitch:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(sound.on==YES)
    {
        appDelegate.sound=YES;
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    else
    {
        appDelegate.sound=NO;
        [[singletonClass sharedsingletonClass].theAudios1 stop];
    }
}
#pragma mark -
#pragma mark inAPP Purchase
- (void)dismissHUD:(id)arg {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.hud removeFromSuperview];
    self.hud = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        [topAds setOn:NO];
        appDelegate.TopAd=NO;
    }
    else
    {
        [topAds setOn:YES];
        appDelegate.TopAd=YES;
    }
    if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
    {
        [bottomAds setOn:NO];
        appDelegate.bottomAd=NO;
    }
    else
    {
        [bottomAds setOn:YES];
        appDelegate.bottomAd=YES;
    }
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]] autorelease];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

-(void)changeUIForPro
{
    [topAds removeFromSuperview];
    [topAdSwitch removeFromSuperview];
    [bottomAds removeFromSuperview];
    [bottomAdSwitch removeFromSuperview];
    [button1Image removeFromSuperview];
    [button2Image removeFromSuperview];
    [head removeFromSuperview];
    [head1 removeFromSuperview];
    [head2 removeFromSuperview];
    [button1 removeFromSuperview];
    [button2 removeFromSuperview];
    
    CGRect frame = loginBg.frame;
    frame.origin.y += 25;
    frame.size.height -= 50;
    
    loginBg.frame = frame;
    
    CGRect frame1 = soundContentView.frame;
    frame1.origin.y += 50;
    soundContentView.frame = frame1;
}

- (void)productPurchased:(NSNotification *)notification 
{
    NSLog(@"Purchased!!!");
    
    [proUpgradeAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    [UserDefaultsManager setProUpgradePurchaseDone:YES];
    [self changeUIForPro];
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {
    
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.hud removeFromSuperview];  
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
            [topAds setOn:NO];
            appDelegate.TopAd=NO;
        }
        else
        {
            [topAds setOn:YES];
            appDelegate.TopAd=YES;
        }
        if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            [bottomAds setOn:NO];
            appDelegate.bottomAd=NO;
        }
        else
        {
            [bottomAds setOn:YES];
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
            [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, 330, moreButton.frame.size.width, moreButton.frame.size.height)];
        }
    }
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    NSLog(@"cancelled");
    [proUpgradeAlert dismissWithClickedButtonIndex:0 animated:YES];
    
//    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeBottomSwitch"] == YES)
//    {
//        
//    }
//    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeTopSwitch"] == YES)
//    {
//        
//    }
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {

    
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.hud removeFromSuperview];
        
        if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            [topAds setOn:NO];
            [UIView setAnimationDuration:0.3];
            
            [self.topAdSwitch setFrame:CGRectMake(171, self.topAdSwitch.frame.origin.y, self.topAdSwitch.frame.size.width, self.topAdSwitch.frame.size.height)];
            [UIView commitAnimations];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeTopSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=NO;
        }
        else
        {
            [topAds setOn:YES];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.TopAd=YES;
        }
        if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            [bottomAds setOn:NO];
            [UIView setAnimationDuration:0.3];
            
            [self.bottomAdSwitch setFrame:CGRectMake(171, self.bottomAdSwitch.frame.origin.y, self.bottomAdSwitch.frame.size.width, self.bottomAdSwitch.frame.size.height)];
            [UIView commitAnimations];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeBottomSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.bottomAd=NO;
        }
        else
        {
            [bottomAds setOn:YES];
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
-(void)loadData{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileExists) {
        
       // NSLog(@"%@",filepath);
        storename = [[NSMutableArray alloc] initWithContentsOfFile:filepath];
    }
    else{
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"];
       // NSLog(@"%@",filePath1);
        storename = [[NSMutableArray alloc] initWithContentsOfFile:filePath1];
    } 
//    NSLog(@"%@",storename);
//    NSLog(@"%d",storename.count);
}
-(void)updateData{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists) {
   //     NSLog(@"%@",filepath);
        [storename writeToFile:filepath atomically:YES];
    }
    else{
     //   NSLog(@"%@",filepath);
        [storename writeToFile:filepath atomically:YES];
    }
    NSLog(@"filepath  %@",filepath);
}
#pragma mark -
#pragma mark Adwhril

- (NSString *)adWhirlApplicationKey {
    NSString *key;
    key=@"d03363079b004be1bd89e9ff4f4e49d9";
    return key;
}

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return self;
}

- (IBAction)moreButtonPressed:(id)sender {
//    [RevMobAds showPopup];
    /* Revm ob
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.delegate = self;
    cb.appId = @"4fe1fe28f87659966f00000d";
    //    cb.appId=@"4fec316df87659b22f000006";
    cb.appSignature = @"3fcf8281d7845374540a0ec5a2f2e7c9ac53c861";
    [cb cacheMoreApps];
    [cb showMoreApps];
     */
    
    [[SNAdsManager sharedManager]  giveMeMoreAppsAd];
}
-(void)didCloseMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (BOOL)shouldDisplayMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    return YES;
}
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
    return YES;
}
-(void)didDismissMoreApps
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
#pragma mark tabbar function
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBar.selectedItem.tag==1)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        
    }
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
