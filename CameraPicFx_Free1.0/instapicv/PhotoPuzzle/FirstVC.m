//
//  FirstVC.m
//  PhotoPuzzle
//
//  Created by Granjur on 01/04/2013.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "FirstVC.h"
#import "LoginPage.h"
#import "UserDefaultsManager.h"
#import "InAppHelperClass.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface FirstVC ()

@end

@implementation FirstVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSMutableString *emailString=[[NSString stringWithFormat:@"<html><body><a href=\"http://georiot.co/ZPM\"></a></body></html>"] mutableCopy];
//    [emailString insertString:@"abcabcabc" atIndex:44];
//    NSLog(@"---->%@",emailString);
    

    // Do any additional setup after loading the view from its nib.
    
    if(![UserDefaultsManager isProUpgradePurchaseDone])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade to Pro" message:@"Upgrade to Pro for just $2.99 to enjoy full access and No ads." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        [alert show];
        [alert release];
    }
    
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
        {
            if (granted)
            {
                // First time access has been granted, add the contact
//                [self _addContactToAddressBook];
            }
            else
            {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        // The user has previously given access, add the contact
//        [self _addContactToAddressBook];
    }
    else
    {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
// block of code to access addreBook details
    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
//    for (CFIndex i = 0; i < CFArrayGetCount(people); i++)
//    {
//        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
//        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
//        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++)
//        {
//            NSString* email = (NSString*)ABMultiValueCopyValueAtIndex(emails, j);
//            NSLog(@"Email: %@",email);
//            [allEmails addObject:email];
//            [email release];
//        }
//        //CFRelease(emails);
//    }
//    CFRelease(addressBook);
//    CFRelease(people);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"header_main.png"];
    
    self.navigationController.navigationBarHidden = YES;
    
//    [navBar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
//    [navBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header_main.png"]]];
    
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:backgroundImage];
//    self.navigationItem.titleView = iv;
    
    CGRect frame = CGRectMake(0, 0, 320, 46);
    iv.frame = frame;
    [self.view addSubview:iv];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[InAppHelperClass getInstance] triggerInApp];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}

- (IBAction)loginPressed:(id)sender {
    
    LoginPage *nextview=[[[LoginPage alloc]init] autorelease];
    nextview.isSignIn = YES;
//    nextview.Email=Email;
    [self.navigationController pushViewController:nextview animated:YES];
}

- (IBAction)signupPressed:(id)sender {
    LoginPage *nextview=[[[LoginPage alloc]init] autorelease];
    nextview.isSignIn = NO;
    //    nextview.Email=Email;
    [self.navigationController pushViewController:nextview animated:YES];
}
@end
