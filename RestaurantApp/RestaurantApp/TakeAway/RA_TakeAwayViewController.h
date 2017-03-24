//
//  RA_TakeAwayViewController.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_TakeAwayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    
    IBOutlet UIDatePicker *datePicker;
}

@end
