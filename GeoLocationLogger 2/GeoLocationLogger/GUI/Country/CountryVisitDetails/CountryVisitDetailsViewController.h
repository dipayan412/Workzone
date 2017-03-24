//
//  CountryVisitDetailsViewController.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryVisitDetailsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UITextField *selectYear;
    
    IBOutlet UIView *yearSelectionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Country:(NSString*)_country;

@property (nonatomic, retain) NSString *country;

@end
