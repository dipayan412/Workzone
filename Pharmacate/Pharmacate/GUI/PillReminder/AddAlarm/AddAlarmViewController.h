//
//  AddAlarmViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/22/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAlarmViewController : UIViewController
{
    IBOutlet UIDatePicker *startDatePicker;
    IBOutlet UIDatePicker *endDatePicker;
    IBOutlet UIDatePicker *startTimePicker;
    IBOutlet UIPickerView *intervalPicker;
    IBOutlet UIPickerView *durationPicker;
    
//    UITextField *searchTextField;
//    NSString *productId;
}

@property(nonatomic, strong) NSMutableArray *productArray;
@property(nonatomic, strong) NSMutableArray *diseaseArray;
@property(nonatomic, strong) NSMutableArray *allergyArray;
@property(nonatomic, strong) NSMutableArray *productAllergeyArray;
@property(nonatomic, strong) UITextField *searchTextField;
@property(nonatomic, strong) NSString *productId;
@property(nonatomic) BOOL isFromProductDetail;
@property(nonatomic, strong) NSString *productName;

-(IBAction)startDatePickerAction:(UIDatePicker*)sender;
-(IBAction)endDatePickerAction:(UIDatePicker*)sender;
-(IBAction)startTimePickerAction:(UIDatePicker*)sender;

@end
