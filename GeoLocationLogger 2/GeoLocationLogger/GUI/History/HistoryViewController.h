//
//  HistoryViewController.h
//  GeoLocationLogger
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTableViewCell.h"

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITextField *selectYearTextField;
    IBOutlet UITableView *containerTableView;
    
    IBOutlet UIView *selectYearView;
}

@end
