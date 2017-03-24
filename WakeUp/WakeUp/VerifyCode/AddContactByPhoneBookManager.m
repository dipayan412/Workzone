//
//  AddContactByPhoneBookManager.m
//  WakeUp
//
//  Created by World on 8/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "AddContactByPhoneBookManager.h"
#import <AddressBook/AddressBook.h>
#import "PhoneBookObject.h"
#import "CountryCodes.h"
#import "Contact.h"
#import "AppDelegate.h"

#define kGroupNumber 20

@implementation AddContactByPhoneBookManager

@synthesize delegate;
static AddContactByPhoneBookManager *instance = nil;

+(AddContactByPhoneBookManager*)getInstance
{
    if(instance == nil)
    {
        instance = [[AddContactByPhoneBookManager alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        phoneBookArray = [[NSMutableArray alloc] init];
        contactsToAddArray = [[NSMutableArray alloc] init];
    }
    return self;
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
                                                                                                         message:@"Sync contacts will not be possible, Change Addressbook settings from Setiings"
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:@"Dismiss"
                                                                                               otherButtonTitles:nil];
                                                         [alert show];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookCheckComplete object:nil];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookContactSyncDone object:nil];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookCheckComplete object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookContactSyncDone object:nil];
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
            
            NSString* output = nil;
            
            if([phoneStr hasPrefix:@"0"])
            {
                output = [phoneStr substringFromIndex:1];
                phoneStr = [NSString stringWithFormat:@"%@%@",[[[CountryCodes getInstance] countryCodesDictionary] objectForKey:[UserDefaultsManager currentCountry]], output];
            }
            
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
            
            if([phoneStr isEqualToString:[UserDefaultsManager userPhoneNumber]])
            {
                continue;
            }
            
            NSLog(@"phone %@",phoneStr);
            
            ABMultiValueRef firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            ABMultiValueRef lastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            CFDataRef dateC = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            NSData *imageData = (__bridge NSData*)dateC;
            
            PhoneBookObject *object = [[PhoneBookObject alloc] init];
            
            NSString *fName =  (__bridge NSString*)firstname;
            NSString *lName =  (__bridge NSString*)lastname;

            object.name = [NSString stringWithFormat:@"%@ %@",fName.length > 0 ? fName : @"", lName.length > 0 ? lName : @""];
            object.phoneNumber = phoneStr;
            object.image = [UIImage imageWithData:imageData];
            
            [phoneBookArray addObject:object];
        }
    }
    
    [contactsToAddArray removeAllObjects];
    totalContacts = (int)phoneBookArray.count;
    int remainder = totalContacts % kGroupNumber;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 0; i < totalContacts; i += kGroupNumber)
        {
            if((i / kGroupNumber) == (totalContacts / kGroupNumber))
            {
                NSArray *arr = [phoneBookArray subarrayWithRange:NSMakeRange(i, remainder)];
                [self checkPhoneBook:arr];
            }
            else
            {
                NSArray *arr = [phoneBookArray subarrayWithRange:NSMakeRange(i, kGroupNumber)];
                [self checkPhoneBook:arr];
            }
            
            if(self.delegate)
            {
                float a = i;
                float b = totalContacts;
                [self.delegate phoneBookSyncProgress:(a / b) * 100 totalContacts:totalContacts syncedContacts:i];
            }
        }
        
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        appDel.registeredContacts = contactsToAddArray;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookCheckComplete object:nil];
    });
    
    CFRelease(addressBook);
    CFRelease(people);
}

-(void)startContactSync
{
    if(contactsToAddArray.count > 0)
    {
        [self addContacts:contactsToAddArray];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhoneBookContactAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhonebookContactSyncDone object:nil];
}

-(void)checkPhoneBook:(NSArray*)array;
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kCheckContactList];
    [urlStr appendFormat:@"&obtoken=%@",[UserDefaultsManager getObserverToken]];
    [urlStr appendFormat:@"&phonenumbers="];
    
    for(int i = 0; i < array.count; i++)
    {
        PhoneBookObject *obj = [array objectAtIndex:i];
        [urlStr appendFormat:@"%@,%@",[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [obj.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(i != array.count - 1)
        {
            [urlStr appendFormat:@","];
        }
    }
    
    NSLog(@"urlStr %@",urlStr);
    
    checkPhoneBookRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [checkPhoneBookRequest startSynchronous];
    
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:checkPhoneBookRequest.responseData options:kNilOptions error:&error];
    NSLog(@"%@ error %@ \nStr %@",responseObject,error,checkPhoneBookRequest.responseString);
    
    [contactsToAddArray addObjectsFromArray:[[responseObject objectForKey:@"body"] objectForKey:@"contactlist"]];
}

-(void)addContacts:(NSArray*)array
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kAddPhoneBookContacts];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&sts=%@",[UserDefaultsManager cSTimeContact]];
    [urlStr appendFormat:@"&contactlist="];
    
    for(int i = 0; i < array.count; i++)
    {
        NSString *phoneStr = [array objectAtIndex:i];
        NSString *name = [self getContactName:phoneStr];
        NSString *nameNumberStr = [NSString stringWithFormat:@"%@,%@",phoneStr,[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [urlStr appendFormat:@"%@",nameNumberStr];
        if(i != array.count - 1)
        {
            [urlStr appendFormat:@","];
        }
    }
    
    NSLog(@"urlStr %@",urlStr);
    
    addContactRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [addContactRequest startSynchronous];
    
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:addContactRequest.responseData options:kNilOptions error:&error];
    NSLog(@"%@ error %@ \nStr %@",responseObject,error,addContactRequest.responseString);
    
    [UserDefaultsManager setCSTimeContact:[[responseObject objectForKey:@"body"] objectForKey:@"cstime"]];
    NSArray *arr = [[responseObject objectForKey:@"body"] objectForKey:@"contactlist"];
    [self insertContact:arr];
}

-(void)insertContact:(NSArray*)array
{
    for(int i = 0; i < array.count; i++)
    {
        NSDictionary *tmpDic = [array objectAtIndex:i];
        
        if(![self isContactAlreadyExist:tmpDic])
        {
            NSError *error = nil;
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
            
            Contact *contact  = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
            
            contact.uid = [tmpDic objectForKey:@"uid"];
            contact.givenName = [tmpDic objectForKey:@"name"];
            contact.phoneNumber = [tmpDic objectForKey:@"phone"];
            NSString *photoId = [NSString stringWithFormat:@"%@", [tmpDic objectForKey:@"pid"]];
            
            if(photoId && photoId.length>0)
            {
                contact.uphotoId = [NSString stringWithFormat:@"%@",photoId];
            }
            
            [context save:&error];
        }
    }
}

-(BOOL)isContactAlreadyExist:(NSDictionary*)tmpDic
{
    NSError *error = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate backgroundManagedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.phoneNumber LIKE[c] %@",[tmpDic objectForKey:@"phone"]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult.count > 0)
    {
        return YES;
    }
    return NO;
}

-(NSString*)getContactName:(NSString*)phoneStr
{
    for(int i = 0; i < phoneBookArray.count; i++)
    {
        PhoneBookObject *obj = [phoneBookArray objectAtIndex:i];
        if([obj.phoneNumber isEqualToString:phoneStr])
        {
            return obj.name;
        }
    }
    return @"";
}

//-(void)checkPhoneBook:(NSArray*)array;
//{
//
//    NSMutableString *urlStr = [[NSMutableString alloc] init];
//    [urlStr appendFormat:@"%@",kBaseUrl];
//    [urlStr appendFormat:@"cmd=%@",kCheckContactList];
//    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
//    [urlStr appendFormat:@"&sts=%@",[UserDefaultsManager cSTimeContact]];
//
//    NSLog(@"addContactUrl %@",urlStr);
//
//    NSMutableArray *arr = [[NSMutableArray alloc] init];;
//
//    for(int i = 0; i < array.count; i++)
//    {
//        PhoneBookObject *obj = [array objectAtIndex:i];
//
//        [arr addObject:obj.phoneNumber];
//    }
//
//    NSError *error = nil;
//    NSData *phoneBookData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:phoneBookData encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonData as string:\n%@", jsonString);
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
//
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    [request setHTTPBody:phoneBookData];
//
//    NSURLResponse *response = nil;
//
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"data %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    if(error)
//    {
//        NSLog(@"error: %@",error.description);
//    }
//    else
//    {
//        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        if(error)
//        {
//            NSLog(@"error: %@",error.description);
//        }
//        else
//        {
//            NSLog(@"Response: %@\n",object);
//            if([[object objectForKey:@"status"] intValue] == 0)
//            {
//                [UserDefaultsManager setCSTimeContact:[[object objectForKey:@"body"] objectForKey:@"cstime"]];
//                NSArray *arr = [[object objectForKey:@"body"] objectForKey:@"contactlist"];
//
//                [contactsToAddArray addObjectsFromArray:arr];
//            }
//        }
//    }
//}

//-(void)addContacts:(NSArray*)array
//{
//    NSMutableString *urlStr = [[NSMutableString alloc] init];
//    [urlStr appendFormat:@"%@",kBaseUrl];
//    [urlStr appendFormat:@"cmd=%@",kAddPhoneBookContacts];
//    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
//    [urlStr appendFormat:@"&sts=%@",[UserDefaultsManager cSTimeContact]];
//
//    NSLog(@"addContactUrl %@",urlStr);
//
//    NSMutableArray *arr = [[NSMutableArray alloc] init];;
//
//    for(int i = 0; i < array.count; i++)
//    {
//        NSString *phoneStr = [array objectAtIndex:i];
//        NSString *name = [self getContactName:phoneStr];
//
//        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
//        [tmpDic setObject:name forKey:@"cname"];
//        [tmpDic setObject:phoneStr forKey:@"cphone"];
//
//        [arr addObject:tmpDic];
//    }
//
//    NSError *error = nil;
//    NSData *phoneBookData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:phoneBookData encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonData as string:\n%@", jsonString);
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
//
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    [request setHTTPBody:phoneBookData];
//
//    NSURLResponse *response = nil;
//
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"data %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    if(error)
//    {
//        NSLog(@"error: %@",error.description);
//    }
//    else
//    {
//        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        if(error)
//        {
//            NSLog(@"error: %@",error.description);
//        }
//        else
//        {
//            NSLog(@"Response: %@\n",object);
//            if([[object objectForKey:@"status"] intValue] == 0)
//            {
//                [UserDefaultsManager setCSTimeContact:[[object objectForKey:@"body"] objectForKey:@"cstime"]];
//                NSArray *arr = [[object objectForKey:@"body"] objectForKey:@"contactlist"];
//                [self insertContact:arr];
////                [contactsToAddArray addObjectsFromArray:arr];
//                // TODO insert in DB
//            }
//        }
//    }
//}

@end
