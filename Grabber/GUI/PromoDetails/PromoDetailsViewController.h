//
//  PromoDetailsViewController.h
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromoObject.h"
#import "PromoDetailsTopCell.h"

@interface PromoDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UITextField *promoNameField;
}

@property (nonatomic, retain) PromoObject *promo;

@end
