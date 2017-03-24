//
//  SelectEmailViewController.h
//  Grabber
//
//  Created by World on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectEmailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *emailTableView;
    IBOutlet UIView *customToolberView;
    IBOutlet UIButton *selectAllButton;
}
-(IBAction)cancelButtonAction:(id)sender;
-(IBAction)inviteButtonAction:(id)sender;
-(IBAction)selectAllButtonAction:(id)sender;

@end
