//
//  MessagesViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"
#import "ContactViewControllerDelegate.h"
#import "MessageRoomViewController.h"

@interface MessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, ContactViewControllerDelegate>
{
    IBOutlet UITableView *containerTableView;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;

@end
