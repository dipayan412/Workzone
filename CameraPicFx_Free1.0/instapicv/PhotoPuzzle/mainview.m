//
//  mainview.m
//  Puzzle
//
//  Created by muhammad sami ather on 6/6/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//

#import "mainview.h"
#import "photoView.h"
#import "SettingPage.h"
#import "photoView.h"
#import "LoginPage.h"
#import "playPuzzle.h"
#import "AppDelegate.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "Parse/Parse.h"
#import "UserDefaultsManager.h"
#import "showAllFriendList.h"
#import "InAppHelperClass.h"

@interface mainview ()

@end

@implementation mainview
@synthesize tabbar;

@synthesize contentView = contentView;
@synthesize morebutton;
@synthesize optionbutton;
@synthesize PuzzleButton;
@synthesize photoTextLabel;
@synthesize welcomeLabel;
@synthesize Email;

@synthesize customizedTabBar;
@synthesize notifier;

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
    self.navigationController.navigationBarHidden = NO;
    
    int rNum = arc4random()%9;
    rNum=rNum+1;
    [self.notifier setImage:[UIImage imageNamed:[NSString stringWithFormat:@"notifier_%u.png",rNum]]];
    
    if (![UserDefaultsManager isProUpgradePurchaseDone])
    {
        [[SNAdsManager sharedManager]  giveMeGameOverAd];
    }
    
    /////// custom tabbar
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    
    
    
    self.customizedTabBar = [nibObjects objectAtIndex:0];
    self.customizedTabBar.frame = CGRectMake(0, self.view.bounds.size.height - customizedTabBar.frame.size.height , customizedTabBar.frame.size.width, 50);
    [self.view addSubview:customizedTabBar];
//    self.customizedTabBar
    [self.customizedTabBar selectTab:11];
    self.customizedTabBar.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.hidesBackButton=YES;
//     tabbar.delegate=self; //Sher
    
  
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [singletonClass sharedsingletonClass].theAudios1.delegate=self;
        [[singletonClass sharedsingletonClass].theAudios1 play];
    }
    
    if([[[ALSharedData getSharedInstance] playHavenInfoObj] showOnMainMenu] == YES)
    {
        [self loadPlayHaven];
    }
    if([[[ALSharedData getSharedInstance] appLovinInfoObj] showOnMainMenu] == YES)
    {
        [ALInterstitialAd showOver:[(AppDelegate*)[[UIApplication sharedApplication] delegate] window]];
    }
    
    if(![UserDefaultsManager isProUpgradePurchaseDone])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to Pro" message:@"Upgrade to Pro for just $2.99 to enjoy full access and No ads." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        [alert show];
        [alert release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[InAppHelperClass getInstance] triggerInApp];
    }
}

-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    [[singletonClass sharedsingletonClass].theAudios1 stop];
    [PFUser logOut];
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
-(void) viewWillAppear:(BOOL)animated
{    
        
    ////////// New By Sher
    ////////SignOut///////
//    
//    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
//    UIButton* suspend1=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 53, 33)];
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    
/*    suspend1.clipsToBounds=YES;  //Commented  By Sher
    
    suspend1.contentMode=UIViewContentModeScaleAspectFit;
    [suspend1 setImage:[UIImage imageNamed:@"signoutbtn.png"] forState:UIButtonTypeCustom];
    [suspend1 addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:suspend1];
    [suspend1 release];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem = customItem;
    [customItem release];
    [rightview release];
 */
    
    ///////////////////////////////
    
    
    
    
    
    [super viewWillAppear:animated];
    
    tabbar.selectedItem=[[self.tabbar items]objectAtIndex:0];
    self.navigationItem.hidesBackButton=YES;    
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
#pragma mark tabbar function
-(void)tabWasSelected:(NSInteger)index
{
    if(index == 11)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.sound==YES)
        {
            [[singletonClass sharedsingletonClass].theAudios play];
        }
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self performSelector:@selector(invite) withObject:nil afterDelay:0.1];
        
    }
    if(index==12)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabbar.selectedItem.tag==1)
    {
        photoView *nextview=[[[photoView alloc]init] autorelease];;
        nextview.Email=Email;
        [self.navigationController pushViewController:nextview animated:NO];
        
    }
}

-(void)invite
{
    PFQuery *query = [PFQuery queryWithClassName:@"AllEmails"];
    [query whereKey:@"Email" equalTo:@"Email"];
    NSArray *usersPosts = [query findObjects];
    showAllFriendList *showall=[[[showAllFriendList alloc]init] autorelease];
    showall.list=[[[NSArray alloc]initWithArray:usersPosts] autorelease];;
    showall.image=[[[UIImage alloc]init] autorelease];
    showall.image=[UIImage imageNamed:@"screen1.png"];
    showall.Email=Email;
    
    showall.realImage=[UIImage imageNamed:@"screen1.png"];
    showall.imageNumber=[[[NSArray alloc]init] autorelease];;
    showall.showAll=NO;
    [self.navigationController pushViewController:showall animated:YES];
}

- (void)viewDidUnload
{
    [self setMorebutton:nil];
    [self setOptionbutton:nil];
    [self setPuzzleButton:nil];
    [self setWelcomeLabel:nil];
    [self setPhotoTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setTabbar:nil];
}

-(void)dealloc
{
    self.notifier = nil;
    [tabbar release];
    [morebutton release];
    [optionbutton release];
    [PuzzleButton release];
    [welcomeLabel release];
    [photoTextLabel release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)MorePressed:(id)sender 
{
    [[SNAdsManager sharedManager]  giveMeMoreAppsAd];
}

- (IBAction)OptionPressed:(id)sender 
{
    SettingPage *showdetail=[[[SettingPage alloc]init] autorelease];
    showdetail.Email=Email;
    [self.navigationController pushViewController:showdetail animated:YES];   
}

- (IBAction)PuzzlePressed:(id)sender
{
    playPuzzle *nextview=[[[playPuzzle alloc]init] autorelease];
    nextview.Email=Email;
    [self.navigationController pushViewController:nextview animated:YES];
}

- (IBAction)SignOutPressed:(id)sender 
{
    LoginPage *sign = [[[LoginPage alloc]init] autorelease];
    [self.navigationController pushViewController:sign animated:YES];
    
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
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.TopAd==NO)
    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=0.0f;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
    }
    if(appDelegate.bottomAd==NO)
    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        //        newFrame.origin.y=322.0f;
//        newFrame.origin.y  = self.view.bounds.size.height - 100;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
    }
    if(appDelegate.TopAd==YES)
    {
        [welcomeLabel setFrame:CGRectMake(welcomeLabel.frame.origin.x, 1, welcomeLabel.frame.size.width, welcomeLabel.frame.size.height)];
        [photoTextLabel setFrame:CGRectMake(photoTextLabel.frame.origin.x, 62, photoTextLabel.frame.size.width, photoTextLabel.frame.size.height)];
        [PuzzleButton setFrame:CGRectMake(morebutton.frame.origin.x, 121, morebutton.frame.size.width, morebutton.frame.size.height)];
        [optionbutton setFrame:CGRectMake(optionbutton.frame.origin.x, 172, optionbutton.frame.size.width, optionbutton.frame.size.height)];
        [morebutton setFrame:CGRectMake(PuzzleButton.frame.origin.x, 220, PuzzleButton.frame.size.width, PuzzleButton.frame.size.height)];
    }
    else
    {
        [welcomeLabel setFrame:CGRectMake(welcomeLabel.frame.origin.x, 51, welcomeLabel.frame.size.width, welcomeLabel.frame.size.height)];
//        [photoTextLabel setFrame:CGRectMake(photoTextLabel.frame.origin.x, 112, photoTextLabel.frame.size.width, photoTextLabel.frame.size.height)];
//        [PuzzleButton setFrame:CGRectMake(morebutton.frame.origin.x, 171, morebutton.frame.size.width, morebutton.frame.size.height)];
//        [optionbutton setFrame:CGRectMake(optionbutton.frame.origin.x, 222, optionbutton.frame.size.width, optionbutton.frame.size.height)];
//        [morebutton setFrame:CGRectMake(PuzzleButton.frame.origin.x, 270, PuzzleButton.frame.size.width, PuzzleButton.frame.size.height)];
    }
    [self.notifier setFrame:CGRectMake((self.morebutton.frame.origin.x + self.morebutton.frame.size.width)-10, self.morebutton.frame.origin.y - 10, self.notifier.frame.size.width, self.notifier.frame.size.height)];

    [super viewWillLayoutSubviews];
}
@end
