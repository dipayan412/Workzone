//
//  PhonebookManager.m
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PhonebookManager.h"
#import <AddressBook/AddressBook.h>
#import "CountryCodes.h"
#import "PhoneBookObject.h"
#import "AppDelegate.h"

@interface PhonebookManager()
{
    NSMutableArray *phoneBookArray;
}

@end

@implementation PhonebookManager

static PhonebookManager *instance = nil;

+(PhonebookManager*)getInstance
{
    if(instance == nil)
    {
        instance = [[PhonebookManager alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        phoneBookArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray*)getPhoneBookContact
{
    [self getAddressBook];
    return phoneBookArray;
}

-(void)getAddressBook
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         [self fetchContacts];
                                                     }
                                                     else
                                                     {
                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                                                                         message:@"Change Addressbook settings from Setiings"
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:@"Dismiss"
                                                                                               otherButtonTitles:nil];
                                                         [alert show];
                                                     }
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        [self fetchContacts];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                        message:@"Change Addressbook settings from Setiings"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)fetchContacts
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
            
//            if([phoneStr rangeOfString:@"+"].location == NSNotFound)
//            {
//                phoneStr = [NSString stringWithFormat:@"%@%@",[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[UserDefaultsManager currentCountry]], phoneStr];
//            }
            
            NSString* output = nil;
            
            if([phoneStr hasPrefix:@"0"])
            {
                output = [phoneStr substringFromIndex:1];
                phoneStr = [NSString stringWithFormat:@"%@%@",[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[UserDefaultsManager currentCountry]], output];
            }
            
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if([phoneStr isEqualToString:[UserDefaultsManager userPhoneNumber]])
            {
                continue;
            }
            
            NSLog(@"phone %@",phoneStr);
            if(![self isContactAlreadyExist:phoneStr])
            {
                ABMultiValueRef firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                ABMultiValueRef lastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
                
                CFDataRef dateC = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                NSData *imageData = (__bridge NSData*)dateC;
                
                PhoneBookObject *object = [[PhoneBookObject alloc] init];
                
                NSString *fName =  (__bridge NSString*)firstname;
                NSString *lName =  (__bridge NSString*)lastname;
                
                if(fName.length > 0)
                {
                    object.name = [NSString stringWithFormat:@"%@ %@",fName.length > 0 ? fName : @"", lName.length > 0 ? lName : @""];
                }
                else
                {
                    object.name = [NSString stringWithFormat:@"%@",lName.length > 0 ? lName : @""];
                }
                
                object.phoneNumber = phoneStr;
                object.image = [UIImage imageWithData:imageData];
                
                [phoneBookArray addObject:object];
            }
        }
    }
    
    [phoneBookArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        PhoneBookObject *p1 = (PhoneBookObject*)obj1;
        PhoneBookObject *p2 = (PhoneBookObject*)obj2;
        
        return [p1.name compare:p2.name options:NSCaseInsensitiveSearch];
    }];
    
    if([UserDefaultsManager phoneBookArray].count > 0)
    {
        [self mergePreviousArray:(NSMutableArray*)[UserDefaultsManager phoneBookArray] WithNewArray:phoneBookArray];
    }
    [UserDefaultsManager setPhoneBookArray:phoneBookArray];
    
    CFRelease(addressBook);
    CFRelease(people);
}

-(BOOL)isContactAlreadyExist:(NSString*)phoneNumber
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.phoneNumber LIKE[c] %@",phoneNumber];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult.count > 0)
    {
        return YES;
    }
    return NO;
}

-(void)mergePreviousArray:(NSMutableArray*)prevArray WithNewArray:(NSMutableArray*)newArray
{
    for(int i = 0; i < newArray.count; i++)
    {
        PhoneBookObject *obj1 = [newArray objectAtIndex:i];
        for(int j = 0; j < prevArray.count; j++)
        {
            PhoneBookObject *obj2 = [prevArray objectAtIndex:j];
            if([obj1.phoneNumber isEqualToString:obj2.phoneNumber] && obj2.isInvited)
            {
                obj1.isInvited = YES;
            }
        }
    }
    phoneBookArray = newArray;
}

@end
