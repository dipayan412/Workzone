//
//  EditJobPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "EditJobPageViewController.h"
#import "JobPageViewController.h"

@interface EditJobPageViewController ()

@end

@implementation EditJobPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    statusField.inputView = statusPicker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [customerNameLabel release];
    [addressLabel release];
    [contactLabel release];
    [phoneLabel release];
    [phoneLabel release];
    [dueDateLabel release];
    [detailsLabel release];
    [notesTextView release];
    [statusPicker release];
    [saveButton release];
    [cancelButton release];
    [statusField release];
    [super dealloc];
}

-(void)logout
{
    // logout process
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    // save process
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
}

- (IBAction)backgroundTap:(id)sender
{
    [statusField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
@end
