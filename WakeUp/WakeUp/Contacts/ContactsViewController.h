//
//  ContactsViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"
#import "ContactViewControllerDelegate.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ContactViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *wakeUsersTableView;
    IBOutlet UITableView *nonWakeUsersTableView;
    
    IBOutlet UICollectionView *wakeUsersCollectionView;
    IBOutlet UICollectionView *nonWakeUsersCollectionView;
    
    IBOutlet UIButton *gridOrTableButton;
    
    IBOutlet UISegmentedControl *contactSegment;
}

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)gridOrTableButtonAction:(UIButton*)sender;
-(IBAction)syncPhoneBookButtonAction:(UIButton*)sender;

-(IBAction)contactSengemtValueShanged:(UISegmentedControl*)sender;

@property (nonatomic, strong) id <DrawerViewDelegate> drawerViewDelegate;

@end
