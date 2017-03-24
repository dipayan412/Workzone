//
//  RA_ItemViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_ItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIView *searchView;
}

@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *categoryName;

-(IBAction)backGroundTap:(id)sender;

@end
