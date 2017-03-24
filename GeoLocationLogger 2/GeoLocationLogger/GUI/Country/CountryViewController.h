//
//  CountryViewController.h
//  GeoLocationLogger
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryTableViewCell.h"

@interface CountryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CountryTableViewCellDelegate>
{
    IBOutlet UITableView *containerTableView;
    
    IBOutlet UIView *selectedYearView;
    IBOutlet UITextField *selectYearTextField;
}

@end
