//
//  RegistrationViewController.m
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "inputTextCell.h"
#import "ProfilePicCell.h"

@interface ProfileViewController () <FBLoginViewDelegate, ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>
{
    ProfilePicCell *topCell;
    
    inputTextCell *firstNameCell;
    inputTextCell *lastNameCell;
    inputTextCell *emailCell;
    inputTextCell *userNameCell;
}

@property (nonatomic,assign) BOOL isFbTapped;
@property (nonatomic, retain) ASIHTTPRequest *getProfileRequest;

@end

@implementation ProfileViewController

@synthesize getProfileRequest;
@synthesize isFbTapped;


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
    
    self.navigationItem.title = @"PROFILE";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    registrationBGView.layer.cornerRadius = 4.0f;
    registrationBGView.backgroundColor = [UIColor whiteColor];
    
    FBLoginView *fbLogin = [[FBLoginView alloc] init];
    fbLogin.frame = CGRectOffset(fbLogin.frame,
                                 (self.view.center.x - (fbLogin.frame.size.width / 2)),
                                 5);
    fbLogin.frame = CGRectMake(100, 280, 40, 40);
    fbLogin.readPermissions = [NSArray arrayWithObjects:@"basic_info", @"email", @"user_likes", nil];
    fbLogin.delegate = self;
    fbLogin.center = self.view.center;
    fbLogin.hidden = YES;
    [self.view addSubview:fbLogin];
    
    self.isFbTapped = NO;
    emailField.text = @"";
    
    [self cellConfiguration];
    
    formTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.delegate = self;
    [formTableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/", baseUrl,getProfileAPI,[UserDefaultsManager sessionToken]];
    NSLog(@"url -> %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    self.getProfileRequest = [ASIHTTPRequest requestWithURL:url];
    self.getProfileRequest.delegate = self;
    [self.getProfileRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSLog(@"%@",request.responseString);
    
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    if([responseObject objectForKey:@"status"] != nil)
    {
        NSDictionary *tmp = [responseObject objectForKey:@"data"];
        if([[responseObject objectForKey:@"status"] intValue] == 0)
        {
            if(![[tmp objectForKey:@"first_name"] isEqualToString:@""])
            {
                firstNameCell.inputField.text = [tmp objectForKey:@"first_name"];
            }
            else
            {
                firstNameCell.inputField.text = @"No first name found";
            }
            
            if(![[tmp objectForKey:@"last_name"] isEqualToString:@""])
            {
                lastNameCell.inputField.text = [tmp objectForKey:@"last_name"];
            }
            else
            {
                lastNameCell.inputField.text = @"No last name found";
            }
            
            emailCell.inputField.text = [tmp objectForKey:@"email"];
            userNameCell.inputField.text = [tmp objectForKey:@"user_name"];
            
            [formTableView reloadData];
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
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:@"Could not connect to server"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)backgroundTap:(UIControl *)sender
{
    [self commitAnimations:64];
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    registrationBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TextBG.png"]];
    emailLabel.textColor = [UIColor whiteColor];
    
    if(textField.tag == 2 || textField.tag == 3)//when these two textfields selected, the keyboard hides the textfield. So the view need to be animated upward and downward
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

-(IBAction)addPhotoBtnAction:(UIButton*)sender
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
//    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    firstNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    firstNameCell.fieldTitleLabel.text = @"First Name";
    firstNameCell.inputField.tag = 0;
    firstNameCell.inputField.delegate = self;
    firstNameCell.inputField.enabled = NO;
    
    lastNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    lastNameCell.fieldTitleLabel.text = @"Last Name";
    lastNameCell.inputField.tag = 1;
    lastNameCell.inputField.delegate = self;
    lastNameCell.inputField.enabled = NO;
    
    emailCell = [[inputTextCell alloc] initWithIsDescription:NO];
    emailCell.fieldTitleLabel.text = @"Email";
    emailCell.inputField.placeholder = @"Type your email address";
    emailCell.inputField.tag = 2;
    emailCell.inputField.delegate = self;
    emailCell.inputField.enabled = NO;
    
    userNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    userNameCell.fieldTitleLabel.text = @"User Name";
    userNameCell.inputField.placeholder = @"Type your desired user name";
    userNameCell.inputField.tag = 3;
    userNameCell.inputField.delegate = self;
    userNameCell.inputField.enabled = NO;
}

@end
