//
//  PromoListViewController.h
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopObject.h"

@interface PromoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
}

@property (nonatomic, retain) ShopObject *shopObject;

@end
