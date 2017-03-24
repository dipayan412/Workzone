//
//  InspectionsPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "InspectionsPageViewController.h"
#import "UserDefaultsManager.h"
#import "Inspections.h"
#import "InspectionList.h"
#import "InspectionListItems.h"
#import "AppDelegate.h"
#import "Devices.h"
#import "InspectionCell.h"

@interface InspectionsPageViewController ()

@end

@implementation InspectionsPageViewController

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
    
    deviceField.inputView = devicePicker;
    inspectionField.inputView = inspectionPicker;
    inspectionField.text = @"";
    
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateSelected];
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [inspectionItemTableView release];
    [devicePicker release];
    [inspectionPicker release];
    [deviceField release];
    [odometerField release];
    [inspectionField release];
    [saveButton release];
    [cancelButton release];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backgroundTap:(id)sender
{
    [deviceField resignFirstResponder];
    [odometerField resignFirstResponder];
    [inspectionField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return [self getInspectionListItems:[self listIdForName:inspectionField.text]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *jobCellId = @"JobCell";
    
    InspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:jobCellId];
    if (cell == nil)
    {
        cell = [[[InspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobCellId withIndexNumber:indexPath.row withStatus:EP_PASSED andNotes:@""] autorelease];
    }
    
    if(inspectionField.text || ![inspectionField.text isEqualToString:@""])
    {
        //NSString *item = [[self getInspectionListItems:[self listIdForName:inspectionField.text]] objectAtIndex:indexPath.section];
        //cell.textLabel.text  = item;
        //cell.label.text = @"1";
        
        cell.nameLabel.text = [[self getInspectionListItems:[self listIdForName:inspectionField.text]] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == inspectionField)
    {
        int row = [inspectionPicker selectedRowInComponent:0];
        inspectionField.text = [[self getInspectionLists] objectAtIndex:row];
        [inspectionItemTableView reloadData];
    }
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
    if(pickerView == devicePicker)
    {
        return [[self getDevices] count];
    }
    else if (pickerView == inspectionPicker)
    {
        return [[self getInspectionLists] count];;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == devicePicker)
    {
        return [[self getDevices] objectAtIndex:row];
    }
    else if(pickerView == inspectionPicker)
    {
        return [[self getInspectionLists] objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == devicePicker)
    {
        deviceField.text = [[self getDevices] objectAtIndex:row];
    }
    else if(pickerView == inspectionPicker)
    {
        inspectionField.text = [[self getInspectionLists] objectAtIndex:row];
        [inspectionItemTableView reloadData];
    }
}

-(NSArray*)getDevices
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *devicesArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Devices *devices in fetchedResult)
        {
            [devicesArray addObject:devices.name];
        }
    }
    return devicesArray;
}

-(NSArray*)getInspectionLists
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionList" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *inspectionListArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (InspectionList *inspectionList in fetchedResult)
        {
            [inspectionListArray addObject:inspectionList.name];
        }
    }
    return inspectionListArray;
}

-(NSArray*)getInspectionListItems:(NSString*)listId
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionListItems" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    if(!listId) return nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.listId LIKE %@",listId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *inspectionListItemArray = [[NSMutableArray alloc] init];
    if (fetchedArray && [fetchedArray count] > 1)
    {
        for (InspectionListItems *item in fetchedArray)
        {
            [inspectionListItemArray addObject:item.name];
            NSLog(@"itemId %@", item.itenId);
        }
    }
    return inspectionListItemArray;
}

-(NSString*)listIdForName:(NSString*)name
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionList" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequst = [[NSFetchRequest alloc] init];
    [fetchRequst setEntity:chartEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name LIKE %@",name];
    [fetchRequst setPredicate:predicate];
    
    NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequst error:&error] mutableCopy];

    if (fetchedArray && [fetchedArray count] > 0)
    {
        InspectionList *item = [fetchedArray objectAtIndex:0];
        return item.listId;
    }
    return nil;
}

/*

-(NSString*)listIdForName:(NSString*)name
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Inspections" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequst = [[NSFetchRequest alloc] init];
    [fetchRequst setEntity:chartEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name LIKE %@",name];
    [fetchRequst setPredicate:predicate];
    
    NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequst error:&error] mutableCopy];
    
    if (fetchedArray && [fetchedArray count] > 0)
    {
        InspectionList *item = [fetchedArray objectAtIndex:0];
        return item.listId;
    }
    return nil;
}
*/

@end
