//
//  MyActivityViewController.h
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"
@interface MyActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    
    IBOutlet UITableView *containerTableView;
    IBOutlet UIView *topBarView;
    IBOutlet UIButton *timeLineSwitchButton;
    IBOutlet UIButton *alarmButton;
    IBOutlet UIView *fullScreenImageBGView;
    IBOutlet UIImageView *fullScreenImageView;
    
}
@property (nonatomic, strong) id <DrawerViewDelegate> drawerViewDelegate;

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)dismissFullScreenImage:(id)sender;
@end
