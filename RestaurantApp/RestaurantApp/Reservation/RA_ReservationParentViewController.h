//
//  RA_ReservationParentViewController.h
//  RestaurantApp
//
//  Created by World on 12/26/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_ReservationParentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
}

@end
