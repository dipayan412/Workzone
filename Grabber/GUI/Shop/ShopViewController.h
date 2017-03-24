//
//  ShopViewController.h
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObject.h"

@interface ShopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *shopeNameLabel;
    IBOutlet UILabel *shopDetailsLabel;
    IBOutlet UIButton *createPromoButton;
    
    IBOutlet UITextField *shopNameTextField;
    IBOutlet UITableView *containerTableView;
}
@property (nonatomic, retain) ShopObject *shopObject;

-(IBAction)promoButtonAction:(UIButton*)btn;

@end
