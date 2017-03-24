//
//  RA_ReservationViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_ReservationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    
    IBOutlet UIDatePicker *datePicker;
}

@end
