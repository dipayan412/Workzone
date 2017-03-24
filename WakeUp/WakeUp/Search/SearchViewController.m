//
//  SearchViewController.m
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCellV2.h"
#import "SearchResultObject.h"
#import "RA_ImageCache.h"
#import <AddressBook/AddressBook.h>
#import "PhoneBookObject.h"
#import "ASIFormDataRequest.h"
#import "CountryCodes.h"
#import "ContactDummyObject.h"
#import "Contact.h"
#import "AppDelegate.h"

@interface SearchViewController () <SearchCellDelegate, UIAlertViewDelegate>
{
    NSMutableArray *searchResultArray;
    NSMutableArray *phoneBookArray;
    NSMutableArray *contactListArray;
    
    ASIHTTPRequest *searchRequest;
    ASIHTTPRequest *addRequest;
    
    RA_ImageCache *imgCh;
    
    int selectedContactIndex;
}

@end

@implementation SearchViewController

@synthesize delegate;

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
    
    imgCh = [[RA_ImageCache alloc] init];
    
    searchResultArray = [[NSMutableArray alloc] init];
    phoneBookArray = [[NSMutableArray alloc] init];
    contactListArray = [[NSMutableArray alloc] init];
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    selectedContactIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddressBookForAddingContact) name:kAddContactComeToFront object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return phoneBookArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchTableCell";
    SearchCellV2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[SearchCellV2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.delegate = self;
    }
    PhoneBookObject *phoneObject = [phoneBookArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = phoneObject.name;
    cell.detailTextLabel.text = phoneObject.phoneNumber;
    cell.imageView.image = phoneObject.image;
    [cell.actionButton setTitle:@"Add" forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)userButtonActionAtIndex:(int)row
{
    NSLog(@"index %d",row);
    selectedContactIndex = row;
    PhoneBookObject *object = [phoneBookArray objectAtIndex:row];
    
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Adding contact"];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kAddContact];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&cphone=%@",[[object.phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"&cname=%@",[object.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    NSLog(@"addCntact urlStr %@",urlStr);
    
    addRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    addRequest.delegate = self;
    addRequest.timeOutSeconds = 60;
    [addRequest startAsynchronous];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.view endEditing:YES];
        [self.delegate showContactViewController];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [userSearchBar resignFirstResponder];
    [self searchServerCall];
}

-(void)searchServerCall
{
    [UserDefaultsManager showBusyScreenToView:self.view WithLabel:@"Searching..."];
    
    [searchResultArray removeAllObjects];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kSearchApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&key=%@",[userSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"search urlStr %@",urlStr);
    
    searchRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    searchRequest.delegate = self;
    [searchRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == searchRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"Search request return %@  \nError %@ \nResponeString %@",responseObject, error, request.responseString);
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            NSArray *arr = [[responseObject objectForKey:@"body"] objectForKey:@"searchresult"];
            for(int i = 0; i < arr.count; i++)
            {
                NSDictionary *tmpDic = [arr objectAtIndex:i];
                
                SearchResultObject *searchObject = [[SearchResultObject alloc] init];
                
                searchObject.userId = [tmpDic objectForKey:@"uid"];
                searchObject.userName = [tmpDic objectForKey:@"uname"];
//                searchObject.userPhotoId = [tmpDic objectForKey:@"pid"];
                searchObject.userPhotoId = [tmpDic objectForKey:@"uphoto"];
                searchObject.userPhone = [tmpDic objectForKey:@"phone"];
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableString *downloadImageUrlStr = [[NSMutableString alloc] init];
                    [downloadImageUrlStr appendFormat:@"%@",kRootUrl];
                    [downloadImageUrlStr appendFormat:@"%@?",kDownloadImageApi];
//                    [downloadImageUrlStr appendFormat:@"imgid=%@",[[[[responseObject objectForKey:@"body"] objectForKey:@"searchresult"] objectAtIndex:i] objectForKey:@"pid"]];
//                    NSLog(@"urlStrImage %@",downloadImageUrlStr);
                [downloadImageUrlStr appendFormat:@"imgid=%@",[[[[responseObject objectForKey:@"body"] objectForKey:@"searchresult"] objectAtIndex:i] objectForKey:@"uphoto"]];
                NSLog(@"urlStrImage %@",downloadImageUrlStr);
//                    searchObject.userImage = [imgCh getImage:downloadImageUrlStr];
//                });
                
                [searchResultArray addObject:searchObject];
            }
            [containerTableView reloadData];
            
            [UserDefaultsManager hideBusyScreenToView:self.view];
        }
        else
        {
            [UserDefaultsManager hideBusyScreenToView:self.view];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(request == addRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"SendContactRequest request return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        
        [UserDefaultsManager hideBusyScreenToView:self.view];
        
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            [UserDefaultsManager setCSTimeContact:[[responseObject objectForKey:@"body"] objectForKey:@"cstime"]];
            NSArray *arr = [[responseObject objectForKey:@"body"] objectForKey:@"contactlist"];
            for(int i = 0; i < arr.count; i++)
            {
                NSDictionary *tmpDic = [arr objectAtIndex:i];
                
                ContactDummyObject *contact = [[ContactDummyObject alloc] init];
                contact.phone = [tmpDic objectForKey:@"phone"];
                contact.uid = [tmpDic objectForKey:@"uid"];
                if([tmpDic objectForKey:@"name"])
                {
                    contact.name = [tmpDic objectForKey:@"name"];
                }
                else
                {
                    PhoneBookObject *object = [phoneBookArray objectAtIndex:selectedContactIndex];
                    contact.name = object.name;
                }
                [contactListArray addObject:contact];
            }
            [self insertContact:contactListArray];
            [self loadContacts];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if([[responseObject objectForKey:@"status"] intValue] == 2 && responseObject)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User does not exist in MilkyWaker" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"SendContactRequest request return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    [UserDefaultsManager hideBusyScreenToView:self.view];
}

-(void)sendRequestButtonPressedAt:(int)row
{
    NSLog(@"rowNum %d",row);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)getAddressBookForAddingContact
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         [self fetchEmails];
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
        [self fetchEmails];
    }
    else
    {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

-(void)fetchEmails
{
    [phoneBookArray removeAllObjects];
    
    CFErrorRef err;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(phone); j++)
        {
            NSString *phoneStr = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, j);
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneStr = [[phoneStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            
            NSLog(@"phoneStr %@",phoneStr);
            
            if([phoneStr rangeOfString:@"+"].location == NSNotFound)
            {
                phoneStr = [NSString stringWithFormat:@"%@%@",[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[UserDefaultsManager currentCountry]], phoneStr];
            }
            
            ABMultiValueRef firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            
            CFDataRef dateC = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            NSData *imageData = (__bridge NSData*)dateC;
            
            PhoneBookObject *object = [[PhoneBookObject alloc] init];
            if(!firstname)
            {
                firstname = @"";
            }
            object.name = [NSString stringWithFormat:@"%@",firstname];
            object.phoneNumber = phoneStr;
            object.image = [UIImage imageWithData:imageData];
            
            if(![self isPhoneAlreadyExist:object])
            {
                [phoneBookArray addObject:object];
            }
        }
        [phoneBookArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            PhoneBookObject *p1 = (PhoneBookObject*)obj1;
            PhoneBookObject *p2 = (PhoneBookObject*)obj2;
            
            return [p1.name compare:p2.name options:NSCaseInsensitiveSearch];
        }];
    }
//    [self checkPhoneBook];
    
    [containerTableView reloadData];
    CFRelease(addressBook);
    CFRelease(people);
}

-(void)checkPhoneBook
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kCheckContactList];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];;
    
    for(int i = 0; i < phoneBookArray.count; i++)
    {
        PhoneBookObject *obj = [phoneBookArray objectAtIndex:i];
        [arr addObject:obj.phoneNumber];
    }
    
    NSError *error = nil;
    NSData *phoneBookData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:phoneBookData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);

//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request setRequestMethod:@"POST"];
//    [request setData:phoneBookData forKey:@"phonebook"];
//    [request setDelegate:self];
//    [request startAsynchronous];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:phoneBookData];
    [request setTimeoutInterval:120];
    
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"error %@\n data %@",error.description, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"Response: %@\n",object);
}

-(void)insertContact:(NSMutableArray*)dummyContactArray
{
    for(int i = 0; i < dummyContactArray.count; i++)
    {
        ContactDummyObject *dummy = [dummyContactArray objectAtIndex:i];
        if(![self isContactAlreadyExist:dummy])
        {
            NSError *error = nil;
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
            
            Contact *contact  = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
            
            contact.uid = dummy.uid;
            contact.givenName = dummy.name;
            contact.phoneNumber = dummy.phone;
            
            [context save:&error];
        }
    }
}

-(BOOL)isContactAlreadyExist:(ContactDummyObject*)dummy
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.phoneNumber LIKE[c] %@ AND SELF.uid LIKE[c] %@",dummy.phone, dummy.uid];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult.count > 0)
    {
        return YES;
    }
    return NO;
}

-(BOOL)isPhoneAlreadyExist:(PhoneBookObject*)dummy
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.phoneNumber LIKE[c] %@",dummy.phoneNumber];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult.count > 0)
    {
        return YES;
    }
    return NO;
}

-(void)loadContacts
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    for(int i = 0; i < fetchedResult.count; i++)
    {
        Contact *contact = [fetchedResult objectAtIndex:i];
        NSLog(@"name %@",contact.givenName);
    }
}

@end
