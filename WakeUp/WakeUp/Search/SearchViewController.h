//
//  SearchViewController.h
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewControllerDelegate.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UISearchBar *userSearchBar;
}

@property (nonatomic, assign) id <ContactViewControllerDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;

@end
