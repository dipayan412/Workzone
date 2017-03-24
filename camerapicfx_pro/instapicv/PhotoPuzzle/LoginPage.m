//
//  LoginPage.m
//  TestApp
//
//  Created by muhammad sami ather on 6/13/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginPage.h"
#import "mainview.h"
//#import "AdWhirlView.h"
//#import "AdWhirlDelegateProtocol.h"
//#import "ChartBoost.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "MBProgressHUD.h"
#import "Parse/Parse.h"
#import "Neocortex.h"
/* Sher
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
 */
static const CGFloat KEYBOARD_ANIMATION_DURATION=0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION=0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION=0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT=150;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT=140;
@interface LoginPage ()

@end

@implementation LoginPage
@synthesize forgetEmail;
@synthesize forgetView;
@synthesize rePasswordSignUp;
@synthesize passwordSignUp;
@synthesize userNameSignUp;
@synthesize passwordsignIn;
@synthesize userNameSignIn;
@synthesize signInView;
@synthesize signUpView;
@synthesize facebookButton = _facebookButton;
@synthesize twitterButton = _twitterButton;
@synthesize toolbarView = _toolbarView;

@synthesize backImage = _backImage;
@synthesize okpressed = _okpressed;
@synthesize loginpage = _loginpage;
@synthesize mimageview = _mimageview;
@synthesize signuplogin = _signuplogin;
@synthesize loginin=_loginin;

@synthesize isSignIn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

/*
#pragma mark - PlayHaven
-(void)loadPlayHaven
{
    PHPublisherContentRequest *request2 = [PHPublisherContentRequest requestForApp:PLAYHAVEN_APP_TOKEN secret:PLAYHAVEN_APP_SECRET placement:@"main_menu" delegate:self];
    [request2 send];
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
*/

- (void)viewDidLoad
{
    /*
    if([[[ALSharedData getSharedInstance] playHavenInfoObj] showOnLevelsMenu] == YES)
    {
        [self loadPlayHaven];
    }
    */
    
    /*
    if([[[ALSharedData getSharedInstance] appLovinInfoObj] showOnLevelsMenu] == YES)
    {
        [ALInterstitialAd showOver:[(AppDelegate*)[[UIApplication sharedApplication] delegate] window]];
    }
    */
    
    NSString* path = [NSHomeDirectory() stringByAppendingString:@"/Documents/myImage.png"];
    jrEngage = [JREngage jrEngageWithAppId:@"idmohlmnppngckgnapfk"
                                         andTokenUrl:nil
                                            delegate:self];
    NSLog(@"%@",path);
    [super viewDidLoad];
    
    
    
  
    
    
    //self.title=@"Photo Puzzle";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.tintColor=[UIColor blueColor];
    
    _toolbarView.backgroundColor=[UIColor blackColor];
    [self.view bringSubviewToFront:_signuplogin];
    [self.view bringSubviewToFront:_loginpage];
//    [singletonClass sharedsingletonClass].adWhrilView=[AdWhirlView requestAdWhirlViewWithDelegate:self];
//    [singletonClass sharedsingletonClass].adWhrilView1=[AdWhirlView requestAdWhirlViewWithDelegate:self];
//    testAds=YES;
    
//    [[Neocortex getInstance] onMainMenu];
    
    if(self.isSignIn)
    {
        [self loginpressed:nil];
    }
    else
    {
         [self signuppressed:nil];
    }
    
//    [RevMobAds showFullscreenAd]; // Sher
}
#pragma mark -
#pragma mark Adwhril

//- (NSString *)adWhirlApplicationKey {
//    NSString *key;
//    key=@"d03363079b004be1bd89e9ff4f4e49d9";
//    return key;
//}
//
- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_main.png"];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = YES;
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
    
//    userNameSignIn.text = @"t@t.com";
//    passwordsignIn.text = @"123456";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if(appDelegate.TopAd==NO&&testAds==YES)
//    {
//        [singletonClass sharedsingletonClass].adWhrilView=[AdWhirlView requestAdWhirlViewWithDelegate:self];
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=0.0;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
//    }
//    if(appDelegate.bottomAd==NO&&testAds==YES)
//    {
//        [singletonClass sharedsingletonClass].adWhrilView1=[AdWhirlView requestAdWhirlViewWithDelegate:self];
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
////        newFrame.origin.y=295.0f;
////        newFrame.origin.y= self.view.bounds.size.height - 100;
//        newFrame.size.height=50.0f;
//        newFrame.origin.y= self.view.bounds.size.height - newFrame.size.height;
//        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
//    }
//    if(testAds==YES)
//    {
//        self.navigationItem.leftBarButtonItem=nil;
//    }
//    testAds=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(appDelegate.TopAd==NO)
//    {
//        [[singletonClass sharedsingletonClass].adWhrilView removeFromSuperview];
//    }
//    if(appDelegate.bottomAd==NO)
//    {
//        [[singletonClass sharedsingletonClass].adWhrilView1 removeFromSuperview];
//    }
}
- (void)viewDidUnload
{
    
    [self setSignuplogin:nil];
    [self setLoginin:nil];
    [self setLoginpage:nil];
    [self setOkpressed:nil];
    [self setMimageview:nil];
    [self setBackImage:nil];
    
    [self setToolbarView:nil];
    [self setTwitterButton:nil];
    [self setFacebookButton:nil];
    [self setSignUpView:nil];
    [self setSignInView:nil];
    [self setUserNameSignIn:nil];
    [self setPasswordsignIn:nil];
    [self setUserNameSignUp:nil];
    [self setPasswordSignUp:nil];
    [self setRePasswordSignUp:nil];
    [self setForgetView:nil];
    [self setForgetEmail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_signuplogin release];
    [_loginin release];
    [_loginpage release];
    [_okpressed release];
    [_mimageview release];
    [_backImage release];
    [_toolbarView release];
    [_twitterButton release];
    [_facebookButton release];
    [signUpView release];
    [signInView release];
    [userNameSignIn release];
    [passwordsignIn release];
    [userNameSignUp release];
    [passwordSignUp release];
    [rePasswordSignUp release];
    [forgetView release];
    [forgetEmail release];
    [super dealloc];
}
- (IBAction)signuppressed:(id)sender 
{
    testAds=NO;
    [self.view addSubview:signUpView];
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
    rightview.backgroundColor=[UIColor clearColor];
    UIButton* suspend=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 53, 33)];
    
    // suspend.layer.cornerRadius=20.0;
    suspend.clipsToBounds=YES;
    
    suspend.contentMode=UIViewContentModeScaleAspectFit;
    [suspend setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIButtonTypeCustom];
    [suspend addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:suspend];
    [suspend release];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.leftBarButtonItem = customItem;
    [customItem release];
    [rightview release];
    [singletonClass sharedsingletonClass].theAudios.delegate=self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(appDelegate.TopAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=0.0;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
//    }
//    if(appDelegate.bottomAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
////        newFrame.origin.y=367.0f;
//        
//        
//        newFrame.size.height=50.0f;
//        newFrame.origin.y= self.view.bounds.size.height - newFrame.size.height;
//        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
//    }
    userNameSignUp.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    userNameSignUp.textColor= [UIColor blackColor];
    userNameSignUp.keyboardType=UIKeyboardTypeEmailAddress;
    userNameSignUp.returnKeyType=UIReturnKeyDone;
    userNameSignUp.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [userNameSignUp addTarget:self action:@selector(textPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[userNameTextField becomeFirstResponder];
    userNameSignUp.text=@"";
    userNameSignUp.tag=0;
    passwordSignUp.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    passwordSignUp.textColor= [UIColor blackColor];
    passwordSignUp.keyboardType=UIKeyboardTypeDefault;
    passwordSignUp.returnKeyType=UIReturnKeyDone;
    //passwordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //[passwordTextField becomeFirstResponder];
    passwordSignUp.text=@"";
    passwordSignUp.tag=1;
    [passwordSignUp addTarget:self action:@selector(textPasswordField1:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [userNameSignUp setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordSignUp setBorderStyle:UITextBorderStyleRoundedRect];
    rePasswordSignUp.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    rePasswordSignUp.textColor= [UIColor blackColor];
    rePasswordSignUp.keyboardType=UIKeyboardTypeDefault;
    rePasswordSignUp.returnKeyType=UIReturnKeyDone;
    //passwordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //[passwordTextField becomeFirstResponder];
    rePasswordSignUp.text=@"";
    rePasswordSignUp.tag=2;
    [rePasswordSignUp addTarget:self action:@selector(textPasswordField1:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [rePasswordSignUp setBorderStyle:UITextBorderStyleRoundedRect];
    signUp=YES;
}

- (IBAction)loginpressed:(id)sender 
{
    testAds=NO;
    [self.view addSubview:signInView];
    userNameSignIn.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    userNameSignIn.textColor= [UIColor blackColor];
    userNameSignIn.keyboardType=UIKeyboardTypeEmailAddress;
    //userNameTextField.returnKeyType=UIReturnKeyDone;
    userNameSignIn.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [userNameSignIn addTarget:self action:@selector(textPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[userNameTextField becomeFirstResponder];
    userNameSignIn.text=@"";
    userNameSignIn.tag=0;
    passwordsignIn.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    passwordsignIn.textColor= [UIColor blackColor];
    passwordsignIn.keyboardType=UIKeyboardTypeDefault;
    //passwordTextField.returnKeyType=UIReturnKeyDone;
    //passwordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //[passwordTextField becomeFirstResponder];
    passwordsignIn.text=@"";
    passwordsignIn.tag=1;
    [passwordsignIn addTarget:self action:@selector(textPasswordField1:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordsignIn setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordsignIn setBorderStyle:UITextBorderStyleRoundedRect];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(0,0,53,44)];
    rightview.backgroundColor=[UIColor clearColor];
    UIButton* suspend=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 53, 33)];
    
    // suspend.layer.cornerRadius=20.0;
    suspend.clipsToBounds=YES;
    
    suspend.contentMode=UIViewContentModeScaleAspectFit;
    [suspend setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIButtonTypeCustom];
    [suspend addTarget:self action:@selector(nameOfSomeMethod1:) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:suspend];
    [suspend release];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.leftBarButtonItem = customItem;
    [customItem release];
    [rightview release];
    [singletonClass sharedsingletonClass].theAudios.delegate=self;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if(appDelegate.TopAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
//        newFrame.origin.y=0.0;
//        newFrame.size.height=50.0f;
//        [singletonClass sharedsingletonClass].adWhrilView.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView];
//    }
//    if(appDelegate.bottomAd==NO)
//    {
//        CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
//        CGRect newFrame ;
//        newFrame.size = adSize;
//        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
////        newFrame.origin.y=367.0f;
////        newFrame.origin.y= self.view.bounds.size.height - 98;
//        newFrame.size.height=50.0f;
//        newFrame.origin.y= self.view.bounds.size.height - newFrame.size.height;
//        [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
//        [self.view addSubview:[singletonClass sharedsingletonClass].adWhrilView1];
//        [self.view setNeedsDisplay];
//    }
//    SignUp  *optiondetail=[[[SignUp alloc]initWithNibName:@"SignUp" bundle:nil] autorelease];
//    self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Back"
//                                                                          style:UIBarButtonItemStylePlain
//                                                                         target:nil 
//                                                                         action:nil] autorelease];
//    
//    [self.navigationController pushViewController:optiondetail animated:YES];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(appDelegate.sound==YES)
//    {
//        [[singletonClass sharedsingletonClass].theAudios play];
//    }
}

- (IBAction)OkButton:(id)sender 
{
    UIButton *button = (UIButton*)sender;
    button.hidden=YES;
    _mimageview.hidden=YES;
    _backImage.hidden=YES;
    _signuplogin.userInteractionEnabled=YES;
    _loginpage.userInteractionEnabled=YES;
    _facebookButton.userInteractionEnabled=YES;
    _twitterButton.userInteractionEnabled=YES;
}

- (IBAction)signInViewButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [passwordsignIn resignFirstResponder];
    [userNameSignIn resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(signIn) withObject:nil afterDelay:0.1];
}
-(void)signIn
{
    
    BOOL correctEmail=NO;
    
    if([passwordsignIn.text length]==0&&[userNameSignIn.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User Name and Password Fields are Empty."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else if([passwordsignIn.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password field is empty."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else if([userNameSignIn.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User Name Field is Empty."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else
    {
        if([userNameSignIn.text length]>0)
        {
            NSArray *pathcomponents;
            pathcomponents=[userNameSignIn.text componentsSeparatedByString:@"@"];
            if([pathcomponents count]==2&&[[pathcomponents objectAtIndex:0] length]>0)
            {
                NSArray *pathcomponents1;
                pathcomponents1=[[pathcomponents objectAtIndex:1] componentsSeparatedByString:@"."];
                if([pathcomponents1 count]==2&&[[pathcomponents1 objectAtIndex:0] length]>0&&[[pathcomponents1 objectAtIndex:1] length]>0)
                {
                    correctEmail=YES;
                }
            }
        }
        if(correctEmail)
        {
            [PFUser logInWithUsernameInBackground:userNameSignIn.text password:passwordsignIn.text 
             block:^(PFUser *user, NSError *error) {
                 if (user) {
                     testAds=YES;
                     [signInView removeFromSuperview];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                                 message:@"You have successfully signed in."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                     [alert show];
                     [alert release];
                     mainview *optiondetail=[[[mainview alloc]init] autorelease];
                     self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@""
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:nil 
                                                                                       action:nil] autorelease];
                     optiondetail.Email=[[[NSString alloc]initWithFormat:@"%@",userNameSignIn.text] autorelease];
                     [self.navigationController pushViewController:optiondetail animated:YES];
                     [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Email ID or Password is incorrect."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                     [alert release];
                     [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                 }
             }];
        }
        else
        {
            UIAlertView *successSubmitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Email id is not in Eligible form." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [successSubmitAlert show];
            [successSubmitAlert release];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
    }
    
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    /*
    signUp=NO;
    [signUpView removeFromSuperview];
    self.navigationItem.leftBarButtonItem=nil;
    CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
    CGRect newFrame ;
    newFrame.size = adSize;
    newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
    newFrame.origin.y=295.0f;
    newFrame.size.height=50.0f;
    [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
     */
}
-(IBAction)nameOfSomeMethod1:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    /*
    [signInView removeFromSuperview];
     self.navigationItem.leftBarButtonItem=nil;
    CGSize adSize = [[singletonClass sharedsingletonClass].adWhrilView1 actualAdSize];
    CGRect newFrame ;
    newFrame.size = adSize;
    newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
    newFrame.origin.y=295.0f;
    newFrame.size.height=50.0f;
    [singletonClass sharedsingletonClass].adWhrilView1.frame = newFrame;
     */
}
- (IBAction)twittersignInButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"twitter"];
}

- (IBAction)facebooksignInButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"facebook"];
}

- (IBAction)signUpViewButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [passwordSignUp resignFirstResponder];
    [userNameSignUp resignFirstResponder];
    [rePasswordSignUp resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(signUp) withObject:nil afterDelay:0.1];
}
-(void)signUp
{
    [passwordSignUp resignFirstResponder];
    [userNameSignUp resignFirstResponder];
    [rePasswordSignUp resignFirstResponder];
    BOOL correctEmail=NO;
    if([userNameSignUp.text length]>0)
    {
        NSArray *pathcomponents;
        pathcomponents=[userNameSignUp.text componentsSeparatedByString:@"@"];
        if([pathcomponents count]==2&&[[pathcomponents objectAtIndex:0] length]>0)
        {
            NSArray *pathcomponents1;
            pathcomponents1=[[pathcomponents objectAtIndex:1] componentsSeparatedByString:@"."];
            if([pathcomponents1 count]==2&&[[pathcomponents1 objectAtIndex:0] length]>0&&[[pathcomponents1 objectAtIndex:1] length]>0)
            {
                correctEmail=YES;
            }
        }
    }
    if([userNameSignUp.text length]==0|[passwordSignUp.text length]==0|[rePasswordSignUp.text length]==0)
    {
        UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:@"Fill all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
        [successSubmitAlert show];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES]; 
    }
    else if(!correctEmail)
    {
        UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:@"e-mail address is not correct." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
        [successSubmitAlert show];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else if(!([passwordSignUp.text isEqualToString:rePasswordSignUp.text]))
    {
        UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:@"Password do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
        [successSubmitAlert show];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else if([passwordSignUp.text length]<6)
    {
        UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:@"Password must be at least 6 character." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
        [successSubmitAlert show];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    else
    {
        NSString *udid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"];
        PFUser *user = [PFUser user];
        user.username = userNameSignUp.text;
        user.email = userNameSignUp.text;
        user.password = passwordSignUp.text;
        NSLog(@"%@",udid);
        [user setObject:udid forKey:@"udid"];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                testAds=YES;
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                // Hooray! Let them use the app now.
                [signUpView removeFromSuperview];
                PFObject *post = [PFObject objectWithClassName:@"AllEmails"];
                [post setObject:userNameSignUp.text forKey:@"email"];
                [post setObject:@"Email" forKey:@"Email"];
                [post save];
                UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"You have successfully signed up." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                [successSubmitAlert show];
                mainview *optiondetail=[[[mainview alloc]init] autorelease];
                self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@""
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:nil 
                                                                                      action:nil] autorelease];
                optiondetail.Email=[[[NSString alloc]initWithFormat:@"%@",userNameSignUp.text] autorelease];
                [self.navigationController pushViewController:optiondetail animated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@.\nTry again",errorString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                [successSubmitAlert show];
            }
        }];
    }
    passwordSignUp.text=@"";
    rePasswordSignUp.text=@"";
    
}


- (IBAction)twitterSignUpButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"twitter"];
    
}

- (IBAction)facebookSignUpButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"facebook"];
}

- (IBAction)forgetPasswordPressed:(id)sender {
    [self.view addSubview:forgetView];
}

- (IBAction)forgetSendPressed:(id)sender {
    forgetEmail.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    forgetEmail.textColor= [UIColor blackColor];
    forgetEmail.keyboardType=UIKeyboardTypeEmailAddress;
    forgetEmail.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [forgetEmail addTarget:self action:@selector(textPasswordField:) forControlEvents:UIControlEventEditingDidEndOnExit];
    forgetEmail.tag=0;
    [self performSelector:@selector(forgetSend) withObject:nil afterDelay:0.1];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
-(void)forgetSend
{
    BOOL correctEmail=NO;
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if([forgetEmail.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email field is Empty."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        if([forgetEmail.text length]>0)
        {
            NSArray *pathcomponents;
            pathcomponents=[forgetEmail.text componentsSeparatedByString:@"@"];
            if([pathcomponents count]==2&&[[pathcomponents objectAtIndex:0] length]>0)
            {
                NSArray *pathcomponents1;
                pathcomponents1=[[pathcomponents objectAtIndex:1] componentsSeparatedByString:@"."];
                if([pathcomponents1 count]==2&&[[pathcomponents1 objectAtIndex:0] length]>0&&[[pathcomponents1 objectAtIndex:1] length]>0)
                {
                    correctEmail=YES;
                }
            }
        }
        if(correctEmail)
        {
            bool userExist=[PFUser requestPasswordResetForEmail:forgetEmail.text];
            if(userExist)
            {
                forgetEmail.text=@"";
                [forgetView removeFromSuperview];
                UIAlertView *successSubmitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Mail sent to your id." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [successSubmitAlert show];
            }
            else{
                UIAlertView *successSubmitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"No such user exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [successSubmitAlert show];
            }
            
        }
        else{
            UIAlertView *successSubmitAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Email id is not in Eligible form." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [successSubmitAlert show];
            [successSubmitAlert release];
            forgetEmail.text=@"";
        }
    }
}
- (IBAction)cancelForgetPressed:(id)sender
{
    forgetEmail.text=@"";
    [forgetView removeFromSuperview];
}

- (IBAction)twitterButtonPressed:(id)sender
{
    signUp=NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"twitter"];
}

- (IBAction)facebookButtonPressed:(id)sender
{
    signUp=NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sound==YES)
    {
        [[singletonClass sharedsingletonClass].theAudios play];
    }
    [jrEngage showAuthenticationDialogForProvider:@"facebook"];
}
- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if(signUp==YES)
    {
        NSLog(@"%@",auth_info);
        NSString *email;
        PFUser *user = [PFUser user];
        
        if([provider isEqualToString:@"twitter"])
        {
            email = [[auth_info objectForKey:@"profile"]
                     objectForKey:@"preferredUsername"];
            user.username = [NSString stringWithFormat:@"%@@twitter.com",email];
            user.email = [NSString stringWithFormat:@"%@@twitter.com",email];
            user.password = @"111111";
        }
        else
        {
            email = [[auth_info objectForKey:@"profile"]
                     objectForKey:@"verifiedEmail"];
            user.username = email;
            user.email = email;
            user.password = @"111111";
        }
        
        NSString *udid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"];
        
        [user setObject:udid forKey:@"udid"];
        NSLog(@"%@",udid);
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (!error)
            {
                testAds=YES;
                PFObject *post = [PFObject objectWithClassName:@"AllEmails"];
                [post setObject:email forKey:@"email"];
                [post setObject:@"Email" forKey:@"Email"];
                [post save];
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                // Hooray! Let them use the app now.
                [signUpView removeFromSuperview];
                UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"You have successfully signed up." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                [successSubmitAlert show];
                mainview *optiondetail=[[[mainview alloc]init] autorelease];
                self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@""
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:nil 
                                                                                      action:nil] autorelease];
                optiondetail.Email=[[[NSString alloc]initWithFormat:@"%@",email] autorelease];
                [self.navigationController pushViewController:optiondetail animated:YES];
            } else
            {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@.\nTry again",errorString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                [successSubmitAlert show];
            }
        }];
    }
    else
    {
        NSLog(@"%@",auth_info);
        NSString *email;
        if([provider isEqualToString:@"twitter"])
            email = [NSString stringWithFormat:@"%@@twitter.com",[[auth_info objectForKey:@"profile"]
                     objectForKey:@"preferredUsername"]];
        else
        {
            email = [[auth_info objectForKey:@"profile"]
                     objectForKey:@"verifiedEmail"];
        }
        
        [PFUser logInWithUsernameInBackground:email password:@"111111" 
         block:^(PFUser *user, NSError *error)
        {
             if (user)
             {
                 testAds=YES;
                 [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                 [signInView removeFromSuperview];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"    message:@"You have successfully signed in."    delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                 mainview *optiondetail=[[[mainview alloc]init] autorelease];
                 self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
                 optiondetail.Email=[[[NSString alloc]initWithFormat:@"%@",email] autorelease];
                 [self.navigationController pushViewController:optiondetail animated:YES];
             } else
             {
                 NSString *email;
                 PFUser *user = [PFUser user];
                 
                 if([provider isEqualToString:@"twitter"])
                 {
                     email = [[auth_info objectForKey:@"profile"]
                              objectForKey:@"preferredUsername"];
                     user.username = [NSString stringWithFormat:@"%@@twitter.com",email];
                     user.email = [NSString stringWithFormat:@"%@@twitter.com",email];
                     user.password = @"111111";
                 }
                 else
                 {
                     email = [[auth_info objectForKey:@"profile"]
                              objectForKey:@"verifiedEmail"];
                     user.username = email;
                     user.email = email;
                     user.password = @"111111";
                 }
                 
                 NSString *udid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"];
                 
                 [user setObject:udid forKey:@"udid"];
                 NSLog(@"%@",udid);
                 [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (!error)
                     {
                         testAds=YES;
                         PFObject *post = [PFObject objectWithClassName:@"AllEmails"];
                         [post setObject:email forKey:@"email"];
                         [post setObject:@"Email" forKey:@"Email"];
                         [post save];
                         [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                         // Hooray! Let them use the app now.
                         [signUpView removeFromSuperview];
                         UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"Congratulations!" message:@"You have successfully signed in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                         [successSubmitAlert show];
                         mainview *optiondetail=[[[mainview alloc]init] autorelease];
                         self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@""
                                                                                                style:UIBarButtonItemStylePlain
                                                                                               target:nil 
                                                                                               action:nil] autorelease];
                         optiondetail.Email=[[[NSString alloc]initWithFormat:@"%@",email] autorelease];
                         [self.navigationController pushViewController:optiondetail animated:YES];
                     } else {
                         [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                         NSString *errorString = [[error userInfo] objectForKey:@"error"];
                         UIAlertView *successSubmitAlert = [[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@.\nTry again",errorString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] autorelease];
                         [successSubmitAlert show];
                     }
                 }];
                 
             }
         }];
    }
    
}
- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error { }

- (void)jrAuthenticationDidNotComplete { }

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl
                            withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload
                             forProvider:(NSString*)provider { }

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider { }

- (void)jrSocialDidNotCompletePublishing { }

- (void)jrSocialDidCompletePublishing { }

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
                       forProvider:(NSString*)provider { }

- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
                  didFailWithError:(NSError*)error
                       forProvider:(NSString*)provider { }
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [userNameSignUp resignFirstResponder];
    [passwordSignUp resignFirstResponder];
    [rePasswordSignUp resignFirstResponder];
    return YES;
}
-(IBAction)textPasswordField:(id)sender {
    
    [sender resignFirstResponder];
    
}
-(IBAction)textPasswordField1:(id)sender {
    
    [sender becomeFirstResponder];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    reedittextfield=textField.tag;
    
    CGRect textFieldRect=[self.view.window convertRect:textField.bounds fromView:textField];
	//CGRect viewRect=[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGRect viewRect=CGRectMake(0, 0, 320, 480);    
	
	CGFloat midline=textFieldRect.origin.y + 0.5*textFieldRect.size.height;
	CGFloat numerator=midline-viewRect.origin.y-MINIMUM_SCROLL_FRACTION*viewRect.size.height;
	CGFloat denominator=(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)*viewRect.size.height;
	CGFloat heightFraction=numerator/denominator;
	
	if (heightFraction<0.0) {
		heightFraction=0.0;
	}
	else if (heightFraction>1.0) {
		heightFraction=1.5;
	}
	
	UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		animatedDistance=floor(PORTRAIT_KEYBOARD_HEIGHT*heightFraction);
	}
	else {
		animatedDistance=floor(LANDSCAPE_KEYBOARD_HEIGHT*heightFraction);
	}
	
	CGRect viewFrame=CGRectMake(0, 0, 320, 480);
	viewFrame.origin.y-=animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    //	[UIView setanimation]
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame=CGRectMake(0, 0, 320, 480);
    [self.view setFrame:viewFrame];
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}

@end
