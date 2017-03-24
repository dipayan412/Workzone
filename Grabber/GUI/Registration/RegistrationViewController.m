//
//  RegistrationViewController.m
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RegistrationViewController.h"
#import "HomeViewController.h"
#import "HomeV2ViewController.h"
#import "HomeV3ViewController.h"
#import "AppDelegate.h"
#import "inputTextCell.h"
#import "ProfilePicCell.h"

@interface RegistrationViewController () <FBLoginViewDelegate, ASIHTTPRequestDelegate,UIGestureRecognizerDelegate, ProPicCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AppDelegateProtocol>
{
    ProfilePicCell *topCell;
    
    inputTextCell *firstNameCell;
    inputTextCell *lastNameCell;
    inputTextCell *emailCell;
    inputTextCell *userNameCell;
}

@property (nonatomic,assign) BOOL isFbTapped;
@property (nonatomic, retain) ASIHTTPRequest *registerRequest;
@property (nonatomic, retain) ASIHTTPRequest *fbSessionTokenRequest;
@end

@implementation RegistrationViewController

@synthesize registerRequest;
@synthesize isFbTapped;
@synthesize fbSessionTokenRequest;


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
    
    self.navigationItem.title = @"REGISTER";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    registrationBGView.layer.cornerRadius = 4.0f;
    registrationBGView.backgroundColor = [UIColor whiteColor];
    
    doneButton.layer.cornerRadius = 4.0f;
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    FBLoginView *fbLogin = [[FBLoginView alloc] init];
    fbLogin.frame = CGRectOffset(fbLogin.frame,
                                 (self.view.center.x - (fbLogin.frame.size.width / 2)),
                                 5);
    fbLogin.frame = CGRectMake(100, 280, 40, 40);
    fbLogin.readPermissions = [NSArray arrayWithObjects:@"basic_info", @"email", @"user_likes",@"read_friendlists",@"read_mailbox",@"user_friends",nil];
    fbLogin.delegate = self;
    fbLogin.center = self.view.center;
    fbLogin.hidden = YES;
    [self.view addSubview:fbLogin];
    
    self.isFbTapped = NO;
    emailField.text = @"";
    
    [self cellConfiguration];
    
    formTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    customNavigationBarView.backgroundColor = [UIColor colorWithRed:202.0f/255.0f green:52.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.delegate = self;
    [formTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        formTableView.scrollEnabled = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
//    statusLabel.text = @"You're logged in as";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
//    fbProfilePicture.profileID = user.id;
//    if(self.isFbTapped)
//    {
//        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
//                                                  message:@""
//                                                 delegate:nil
//                                        cancelButtonTitle:nil
//                                        otherButtonTitles:nil];
//        [loadingAlert show];
//        
//        emailCell.inputField.text = [user objectForKey:@"email"];
//        firstNameCell.inputField.text = [user objectForKey:@"first_name"];
//        lastNameCell.inputField.text = [user objectForKey:@"last_name"];
//        userNameCell.inputField.text = [user objectForKey:@"username"];
////        topCell.imageView.image = user.id;
//        
//        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
//            if (error)
//            {
//                // Handle error
//            }
//            
//            else {
////                NSString *username = [user objectForKey:@""];
//                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"username"]];
//                NSLog(@"url -> %@",userImageURL);
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]];
//                topCell.proPicImageView.image = [UIImage imageWithData:data];
//                topCell.proPicImageView.layer.cornerRadius = topCell.proPicImageView.bounds.size.width/2;
//                topCell.proPicImageView.layer.masksToBounds = YES;
//                [formTableView reloadData];
//                [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
//                
//                [self registerAction];
//            }
//        }];
//    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
//    fbProfilePicture.profileID = nil;
//    nameLabel.text = @"";
//    statusLabel.text= @"You're not logged in!";
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    
}

-(IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonAction:(UIButton*)sender
{
//    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self registerAction];
}

-(void)registerAction
{
    [firstNameCell.inputField resignFirstResponder];
    [lastNameCell.inputField resignFirstResponder];
    [emailCell.inputField resignFirstResponder];
    [userNameCell.inputField resignFirstResponder];
    
    if([emailCell.inputField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter your email address"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if([userNameCell.inputField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter desired username"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([self NSStringIsValidEmail:emailCell.inputField.text])
    {
        NSLog(@"valid");
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",registerapi];
        [urlStr appendFormat:@"%@/", [emailCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [urlStr appendFormat:@"%@/", [userNameCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if(![firstNameCell.inputField.text isEqualToString:@""])
        {
            [urlStr appendFormat:@"%@/", [firstNameCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        if(![lastNameCell.inputField.text isEqualToString:@""])
        {
            [urlStr appendFormat:@"%@/", [lastNameCell.inputField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSLog(@"%@",urlStr);
        
        urlStr = (NSMutableString*)[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        self.registerRequest = [ASIHTTPRequest requestWithURL:url];
        registerRequest.delegate = self;
        [registerRequest startAsynchronous];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
    }
    else
    {
        NSLog(@"invalid");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid e-mail address"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == self.registerRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",responseObject);
        
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        if([[responseObject objectForKey:@"status"] integerValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Password sent to given email address"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] integerValue] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                            message:@"Email address already taken"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] integerValue] == 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[responseObject objectForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(request == self.fbSessionTokenRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",responseObject);
        
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        if([responseObject objectForKey:@"status"] != nil)
        {
            if([[responseObject objectForKey:@"status"] integerValue] == 0)
            {
                NSString *sessionToken = [responseObject objectForKey:@"session_token"];
                [UserDefaultsManager setSessionToken:sessionToken];
                
                NSString *userMerchant = [responseObject objectForKey:@"marchent"];
                [UserDefaultsManager setUserMerchant:[userMerchant boolValue]];
                
                [self gotoHome];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[responseObject objectForKey:@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"dismiss"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Something went wrong. Please try again later"
                                                           delegate:nil
                                                  cancelButtonTitle:@"dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)gotoHome
{
    if(![UserDefaultsManager isMerchantModeOn] || ![UserDefaultsManager isUserMerchant])
    {
        [UserDefaultsManager setBeaconsEnabledOn:YES];
    }
    
    [[PromoScanner getInstance] startPromoScanner];
    
//    HomeV2ViewController *vc = [[HomeV2ViewController alloc] initWithNibName:@"HomeV2ViewController" bundle:nil];
    HomeV3ViewController *vc = [[HomeV3ViewController alloc] initWithNibName:@"HomeV3ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backgroundTap:(UIControl *)sender
{
    [self commitAnimations:64];
    [self.view endEditing:YES];
    
    [firstNameCell.inputField resignFirstResponder];
    [lastNameCell.inputField resignFirstResponder];
    [emailCell.inputField resignFirstResponder];
    [userNameCell.inputField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    registrationBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TextBG.png"]];
    emailLabel.textColor = [UIColor whiteColor];
    
    if(textField.tag == 1)
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-30];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
    
    if(textField.tag == 2)
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-60];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
    
    if(textField.tag == 3)
    {
        if([UIScreen mainScreen].bounds.size.height <= 568)
        {
            [self commitAnimations:-120];
        }
        else
        {
            [self commitAnimations:0];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self commitAnimations:64];
    
    registrationBGView.backgroundColor = [UIColor whiteColor];
    emailLabel.textColor = [UIColor lightGrayColor];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [lastNameCell.inputField becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [emailCell.inputField becomeFirstResponder];
    }
    else if(textField.tag == 2)
    {
        [userNameCell.inputField becomeFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [formTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if(textField.tag == 3)
    {
        [self registerAction];
    }
    
    return YES;
}

-(void)commitAnimations:(int)y
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect frame = self.view.frame;
    frame.origin.y = y;
    self.view.frame = frame;
    [UIView commitAnimations];
}

-(IBAction)fbButtonAction:(UIButton*)sender
{
// If the session state is any of the two "open" states when the button is clicked
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//
//        // Close the session and remove the access token from the cache
//        // The session state handler (in the app delegate) will be called automatically
//        [FBSession.activeSession closeAndClearTokenInformation];
//
//        // If the session state is not any of the two "open" states when the button is clicked
//    } else {
// Open a session showing the user the login UI
// You must ALWAYS ask for basic_info permissions when opening a session
    
    if([[FBSession activeSession] isOpen])
    {
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbToken %@",token);
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",facebookLoginApi];
        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        self.fbSessionTokenRequest.delegate = self;
        [self.fbSessionTokenRequest startAsynchronous];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
    }
    else
    {
        AppDelegate *apdl = (AppDelegate*)[UIApplication sharedApplication].delegate;
        apdl.delegate = self;
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"read_friendlists",@"read_mailbox"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             self.isFbTapped = YES;
         }];
    }
//    }
}

-(void)cameBackToApp
{
    if([[FBSession activeSession] isOpen])
    {
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbToken %@",token);
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@",baseUrl];
        [urlStr appendFormat:@"%@",@"fblogin/"];
        [urlStr appendFormat:@"%@",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.fbSessionTokenRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        self.fbSessionTokenRequest.delegate = self;
        [self.fbSessionTokenRequest startAsynchronous];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
    }
}

-(IBAction)twitterButtonAction:(UIButton*)sender
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultFooter";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView)
    {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fbButton.frame = CGRectMake(161, 10, 140, 40);
        
        twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.frame = CGRectMake(19, 10, 140, 40);
        
        UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 0, 10, 60)];
        orLabel.text = @"or";
        orLabel.textColor = [UIColor lightGrayColor];
        orLabel.font = [UIFont systemFontOfSize:11.0f];
        
        [fbButton setBackgroundImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
        [twitterButton  setBackgroundImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
        
        [fbButton addTarget:self action:@selector(fbButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [twitterButton addTarget:self action:@selector(twitterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:bgView];
        [footerView addSubview:fbButton];
        [footerView addSubview:twitterButton];
        [footerView addSubview:orLabel];
    }
    
    return footerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return topCell;
            
        case 1:
            return firstNameCell;
            
        case 2:
            return lastNameCell;
            
        case 3:
            return emailCell;
            
        case 4:
            return userNameCell;
            
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 140.0f;
    }
    return 50.0f;
}

-(void)cellConfiguration
{
    topCell = [[ProfilePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.accessoryType = UITableViewCellAccessoryNone;
    topCell.proPicImageView.image = [UIImage imageNamed:@"ProPicIcon.png"];
    topCell.delegate = self;
    
    firstNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    firstNameCell.fieldTitleLabel.text = @"First Name";
    firstNameCell.inputField.placeholder = @"Type your first name";
    firstNameCell.inputField.tag = 0;
    firstNameCell.inputField.delegate = self;
    firstNameCell.inputField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    firstNameCell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameCell.inputField.returnKeyType = UIReturnKeyNext;
    
    lastNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    lastNameCell.fieldTitleLabel.text = @"Last Name";
    lastNameCell.inputField.placeholder = @"Type your last name";
    lastNameCell.inputField.tag = 1;
    lastNameCell.inputField.delegate = self;
    lastNameCell.inputField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    lastNameCell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    lastNameCell.inputField.returnKeyType = UIReturnKeyNext;
    
    emailCell = [[inputTextCell alloc] initWithIsDescription:NO];
    emailCell.fieldTitleLabel.text = @"Email";
    emailCell.inputField.placeholder = @"Type your email address";
    emailCell.inputField.tag = 2;
    emailCell.inputField.delegate = self;
    emailCell.inputField.keyboardType = UIKeyboardTypeEmailAddress;
    emailCell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailCell.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailCell.inputField.returnKeyType = UIReturnKeyNext;
    
    userNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    userNameCell.fieldTitleLabel.text = @"User Name";
    userNameCell.inputField.placeholder = @"Type your desired user name";
    userNameCell.inputField.tag = 3;
    userNameCell.inputField.delegate = self;
    userNameCell.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameCell.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameCell.inputField.returnKeyType = UIReturnKeyDone;
}

-(void)proPicButtonAction
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    topCell.proPicImageView.image = img;
    [formTableView reloadData];
}

-(IBAction)addPhotoBtnAction:(UIButton*)sender
{
    
}

@end
