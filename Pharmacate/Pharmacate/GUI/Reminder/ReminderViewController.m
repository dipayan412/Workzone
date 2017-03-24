//
//  ReminderViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation ReminderViewController
{
    NSArray *typeArray;
    NSArray *frequencyArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1.0f];
    detailsView.layer.borderColor = [UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255].CGColor;
    detailsView.layer.borderWidth = 1.0f;
    
    reminderView.layer.borderColor = [UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255].CGColor;
    reminderView.layer.borderWidth = 1.0f;
    
    typeTextField.inputView = typePicker;
    frequencyTextField.inputView = frequencyPicker;
    timeTextField.inputView = timePicker;
    
    typeArray = [NSArray arrayWithObjects:@"Pill", @"Syrup", @"Injection", nil];
    frequencyArray = [NSArray arrayWithObjects:@"Once", @"Twice", @"Thrice", @"Four", @"Never", nil];
    
    frequencyPicker.showsSelectionIndicator = YES;
    typePicker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBarType= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBarType setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(selectTypePicker)];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBarType.items = @[space1, barButtonDone1];
    barButtonDone1.tintColor=[UIColor blackColor];
    typeTextField.inputAccessoryView = toolBarType;
    
    UIToolbar *toolBarFrequency= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBarFrequency setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone2 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(selectFrequencyPicker)];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBarFrequency.items = @[space2, barButtonDone2];
    barButtonDone2.tintColor=[UIColor blackColor];
    frequencyTextField.inputAccessoryView = toolBarFrequency;
    
    UIToolbar *toolBarTime = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBarTime setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone3 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(selectTimePicker)];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBarTime.items = @[space3, barButtonDone3];
    barButtonDone3.tintColor=[UIColor blackColor];
    timeTextField.inputAccessoryView = toolBarTime;
}

-(void)selectTypePicker
{
    typeTextField.text = [typeArray objectAtIndex:[typePicker selectedRowInComponent:0]];
    [typeTextField resignFirstResponder];
}

-(void)selectFrequencyPicker
{
    frequencyTextField.text = [frequencyArray objectAtIndex:[frequencyPicker selectedRowInComponent:0]];
    [frequencyTextField resignFirstResponder];
}

-(void)selectTimePicker
{
    [timeTextField resignFirstResponder];
}

-(IBAction)timePickerValueChanged:(UIDatePicker*)sender
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    timeTextField.text = [outputFormatter stringFromDate:sender.date];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == typePicker)
    {
        return typeArray.count;
    }
    else
    {
        return frequencyArray.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == typePicker)
    {
        return [typeArray objectAtIndex:row];
    }
    else
    {
        return [frequencyArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == typePicker)
    {
        typeTextField.text = [typeArray objectAtIndex:row];
    }
    else
    {
        frequencyTextField.text = [frequencyArray objectAtIndex:row];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == noteTextField)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == noteTextField)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
