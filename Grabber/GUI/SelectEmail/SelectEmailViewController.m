//
//  SelectEmailViewController.m
//  Grabber
//
//  Created by World on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SelectEmailViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "PersonObject.h"
#import "EmailCell.h"

@interface SelectEmailViewController () <EmailCellDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate>
{
    NSMutableArray *personArray;
    NSMutableArray *fbFriendsProPicArray;
    UIAlertView *loadingAlert;
    ASIHTTPRequest *sendFbInvitationRequest;
    
    BOOL isSelectAllSelected;
}

@end

@implementation SelectEmailViewController

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
    
    self.navigationItem.title = @"GRABBER";
    
    personArray = [[NSMutableArray alloc] init];
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
    
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              NSArray *data = [result objectForKey:@"data"];
                              for(int i = 0; i < data.count; i++)
                              {
                                  NSDictionary *tmpDic = [data objectAtIndex:i];
                                  
                                  PersonObject *person = [[PersonObject alloc] init];
                                  person.name = [tmpDic objectForKey:@"name"];
                                  person.fbId = [tmpDic objectForKey:@"id"];
                                  
                                  [personArray addObject:person];
                              }
                              
                              [personArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                
                                  PersonObject *p1 = (PersonObject*)obj1;
                                  PersonObject *p2 = (PersonObject*)obj2;
                                  
                                  return [p1.name compare:p2.name];
                              }];
                              [emailTableView reloadData];
                              [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                          }];
//    customToolberView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TakePhotoButtonBG.png"]];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 16, 16)];
    [button addTarget:self action:@selector(selectAllFrinds) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    img.frame = CGRectMake(-12, 7, 21, 19);
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addSubview:img];
    [button1 addTarget:self action:@selector(cancelButtonProcedure) forControlEvents:UIControlEventTouchUpInside];
    [button1 setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)cancelButtonProcedure
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendProcedure
{
    NSMutableArray *personsToSendInvitation = [[NSMutableArray alloc] init];
    for(PersonObject *person in personArray)
    {
        if(person.isSelected)
        {
            [personsToSendInvitation addObject:person.fbId];
        }
    }
    
    if(personsToSendInvitation.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Select atleast 1 friend"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",fbSendInvitationApi];
    [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%@/",[[[FBSession activeSession] accessTokenData] accessToken]];
    for(int i = 0; i < personsToSendInvitation.count; i++)
    {
        [urlStr appendFormat:@"%@",[personsToSendInvitation objectAtIndex:i]];
        if(i != personsToSendInvitation.count - 1)
        {
            [urlStr appendFormat:@"-"];
        }
    }
    [urlStr appendFormat:@"/"];
    
    NSString *str = urlStr;
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *str1 = [[NSMutableString alloc] init];
    [str1 appendFormat:@"%@",str];
    NSLog(@"request %@",str1);
    
    sendFbInvitationRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    sendFbInvitationRequest.delegate = self;
    [sendFbInvitationRequest startAsynchronous];
    
    loadingAlert.title = @"Sending...";
    [loadingAlert show];
}

#pragma mark ASIHTTPRequest stack

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"Response: %@", request.responseString);
    
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    
    if([[responseObject objectForKey:@"status"] integerValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you for sharing"
                                                        message:@"You just won more Reward points"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:request.error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark UIAlertView stack

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView stack

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return personArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EmailCell";
    EmailCell *cell = [emailTableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[EmailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:131.0f/255.0f green:73.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    PersonObject *person = [personArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = person.name;
    
    if (person.proPic)
    {
        cell.proPicImgView.image = person.proPic;
    }
    else
    {
        cell.proPicImgView.image = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",person.fbId]]];

            if (imgData)
            {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image)
                {
                    person.proPic = image;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        EmailCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                        {
                            updateCell.proPicImgView.image = image;
                        }
                    });
                }
            }
        });
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmailCell *cell = (EmailCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell checkBoxButtonAction];
}

#pragma mark EmailCellDelegate stack

-(void)emailSelected:(BOOL)_isSelected atIndexPath:(NSIndexPath *)_indexPath
{
    PersonObject *person = [personArray objectAtIndex:_indexPath.row];
    person.isSelected = _isSelected;
    [personArray replaceObjectAtIndex:_indexPath.row withObject:person];
}

-(IBAction)cancelButtonAction:(id)sender
{
//    [self cancelButton];
}

-(IBAction)inviteButtonAction:(id)sender
{
    [self sendProcedure];
}

-(IBAction)selectAllButtonAction:(id)sender
{
    
}

-(void)selectAllFrinds
{
    isSelectAllSelected = !isSelectAllSelected;
    for(int i = 0; i < personArray.count; i++)
    {
        if(isSelectAllSelected)
        {
            EmailCell *cell = (EmailCell*)[emailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell selectAllCheckBox];
            
            UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, 16, 16)];
            [button addTarget:self action:@selector(selectAllFrinds) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        else
        {
            EmailCell *cell = (EmailCell*)[emailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell deselectAllCheckBox];
            UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, 16, 16)];
            [button addTarget:self action:@selector(selectAllFrinds) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
    [emailTableView reloadData];
}

// +*+*+*+ this code is for accessing phone address book

//-(void)shareToWinAction
//{
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//    
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
//    {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
//                                                 {
//                                                     if (granted)
//                                                     {
//                                                         [self fetchEmails];
//                                                     }
//                                                     else
//                                                     {
//                                                         // User denied access
//                                                         // Display an alert telling user the contact could not be added
//                                                     }
//                                                 });
//    }
//    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
//    {
//        [self fetchEmails];
//    }
//    else
//    {
//        // The user has previously denied access
//        // Send an alert telling user to change privacy setting in settings app
//    }
//}
//
//-(void)fetchEmails
//{
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    for (CFIndex i = 0; i < CFArrayGetCount(people); i++)
//    {
//        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
//        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
//        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++)
//        {
//            NSString *email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
//            ABMultiValueRef firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//            ABMultiValueRef lastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
//            
//            PersonObject *person = [[PersonObject alloc] init];
//            person.name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
//            person.email = email;
//            
//            [personArray addObject:person];
//        }
//        //CFRelease(emails);
//    }
//    
//    CFRelease(addressBook);
//    CFRelease(people);
//}

@end
