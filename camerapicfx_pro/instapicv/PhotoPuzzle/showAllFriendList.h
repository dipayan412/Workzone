//
//  showAllFriendList.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/21/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVAudioPlayer.h>
@interface showAllFriendList : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,AVAudioPlayerDelegate>
{
    NSArray *list;
    UIImage *image;
    UIImage *realImage;
    NSString *Email;
    NSArray *imageNumber;
    NSMutableArray *finalList;
    NSInteger totalParts;
    BOOL showAll;
    ////sound
    BOOL playsound;
}
@property BOOL showAll;
@property NSInteger totalParts;
@property (retain, nonatomic)NSArray *imageNumber;
@property (retain, nonatomic)NSString *Email;
@property (retain, nonatomic)UIImage *image;
@property (retain, nonatomic)UIImage *realImage;
@property (retain, nonatomic) NSArray *list;
@property (retain, nonatomic) IBOutlet UITableView *allFreindList;
-(void)displayComposerSheet;
@end
