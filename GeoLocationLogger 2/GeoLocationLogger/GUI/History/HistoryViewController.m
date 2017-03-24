//
//  HistoryViewController.m
//  GeoLocationLogger
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "HistoryViewController.h"
#import "SettingsViewController.h"
#import "HistoryTableViewCell.h"
#import "VisitDetailViewController.h"
#import "NSDate+Extension.h"

@interface HistoryViewController ()
{
    UIPickerView *yearPicker;
    int selectedYear;
}

@property (nonatomic, retain) NSArray *gllVisitListArray;

@end

@implementation HistoryViewController

@synthesize gllVisitListArray;

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
    
    self.title = @"History";
    self.view.backgroundColor = kApplicationBackground;
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0f / 255.0f green:52.0f/255.0f blue:52.0f / 255.0f alpha:1.0f];
    }
    
    selectYearView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"YearDropdownBG.png"]];
    
    selectedYear = [[NSDate date] year];
    
    selectYearTextField.text = [NSString stringWithFormat:@"%d", selectedYear];
    selectYearTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown.png"]];
    selectYearTextField.rightViewMode = UITextFieldViewModeAlways;
    
    yearPicker = [[UIPickerView alloc] init];
    yearPicker.delegate = self;
    [yearPicker selectRow:(selectedYear - kBaseYear) inComponent:0 animated:NO];
    
    selectYearTextField.inputView = yearPicker;
    
    gllVisitListArray = [[NSMutableArray alloc] init];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePicker)];
    doneButton.tintColor = [UIColor blackColor];
    [toolBar setItems:[NSArray arrayWithObjects:space ,doneButton, nil]];
    
    selectYearTextField.inputAccessoryView = toolBar;
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
    [settingsButton sizeToFit];
    [settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchGllVisitByYear:selectedYear];
    [containerTableView reloadData];
}

-(void)hidePicker
{
    [self fetchGllVisitByYear:selectedYear];
    [selectYearTextField resignFirstResponder];
    [containerTableView reloadData];
}

-(void)fetchGllVisitByYear:(int)year
{
    NSError *error = nil;
    
    NSDate *startingDate = [NSDate firstDateOfYear:year];
    NSDate *endingDate = [NSDate firstDateOfYear:(year + 1)];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date >= %@ AND SELF.date < %@", startingDate, endingDate];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(fetchedResult.count > 0)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy";
        for(int i = 0; i < fetchedResult.count; i++)
        {
            self.gllVisitListArray = fetchedResult;
        }
    }
    else
    {
        self.gllVisitListArray = nil;
    }
}

-(void)settingsButtonAction
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gllVisitListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    GLLVisit *visit = [gllVisitListArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    if(visit.hasPhoto.boolValue)
    {
        cell.attachmentImageView.image = [UIImage imageNamed:@"attachmentIcon.png"];
    }
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:visit.date]];
    cell.cityCountryLabel.text = [NSString stringWithFormat:@"%@, %@",visit.city, visit.country];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitDetailViewController *vc = [[VisitDetailViewController alloc] initWithNibName:@"VisitDetailViewController" bundle:nil GLLVisit:[gllVisitListArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[NSDate date] year] - kBaseYear + 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(yearPicker == pickerView)
    {
        NSString *year = [NSString stringWithFormat:@"%d", kBaseYear + row];
        return year;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(yearPicker == pickerView)
    {
        selectedYear = kBaseYear + row;
        selectYearTextField.text = [NSString stringWithFormat:@"%d", selectedYear];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [yearPicker selectRow:(selectedYear - kBaseYear) inComponent:0 animated:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
