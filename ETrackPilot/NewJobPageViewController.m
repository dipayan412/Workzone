//
//  NewJobPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "NewJobPageViewController.h"

@interface NewJobPageViewController ()

@end

@implementation NewJobPageViewController

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
    
    [scrollView addSubview:contentView];
    
    contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    statusField.inputView = statusPicker;
    dueDateField.inputView = datePicker;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        contentView.frame = self.view.frame;
    }
    
    scrollView.contentSize = contentView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [customerNameField release];
    [addressField release];
    [contactField release];
    [phoneNumberField release];
    [detailsEditView release];
    [notesTextView release];
    [statusPicker release];
    [datePicker release];
    [dueDateField release];
    [statusField release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    
}  

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

-(IBAction)backgroundTap:(id)sender
{
    // resign all first responder
    [customerNameField resignFirstResponder];
    [addressField resignFirstResponder];
    [phoneNumberField resignFirstResponder];
    [dueDateField resignFirstResponder];
    [statusField resignFirstResponder];
    [contactField resignFirstResponder];
    
    [detailsEditView resignFirstResponder];
    [notesTextView resignFirstResponder];
    
}

@end
