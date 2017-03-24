//
//  AddContactByPhoneBookManager.h
//  WakeUp
//
//  Created by World on 8/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddContactByPhoneBookDelegate <NSObject>

-(void)phoneBookSyncProgress:(int)value totalContacts:(int)total syncedContacts:(int)synced;

@end

@interface AddContactByPhoneBookManager : NSObject <ASIHTTPRequestDelegate>
{
    NSMutableArray *phoneBookArray;
    NSMutableArray *contactsToAddArray;
    int totalContacts;
    
    ASIHTTPRequest *checkPhoneBookRequest;
    ASIHTTPRequest *addContactRequest;
}
@property (nonatomic, assign) id <AddContactByPhoneBookDelegate> delegate;
+(AddContactByPhoneBookManager*)getInstance;
-(void)getAddressBook;
-(void)startContactSync;

@end
