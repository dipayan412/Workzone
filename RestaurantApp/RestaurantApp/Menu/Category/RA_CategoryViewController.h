//
//  RA_CategoryViewController.h
//  RestaurantApp
//
//  Created by World on 1/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UITableView *containerTableView;
}

@end
