//
//  CountryVisitDetailsViewController.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "CountryVisitDetailsViewController.h"
#import "CountryVisitDetailsCell.h"
#import "GLLVisit.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "NSDate+Extension.h"

@interface CountryVisitDetailsViewController ()
{
    int selectedYear;
    UIPickerView *yearPicker;
}

@property (nonatomic, retain) NSMutableArray *gllVisitList;

@end

@implementation CountryVisitDetailsViewController

@synthesize country;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Country:(NSString*)_country
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.country = _country;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",self.country];
    self.view.backgroundColor = kApplicationBackground;
    
    yearSelectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"YearDropdownBG.png"]];
    
    selectedYear = [[NSDate date] year];
    
    yearPicker = [[UIPickerView alloc] init];
    yearPicker.delegate = self;
    [yearPicker selectRow:(selectedYear - kBaseYear) inComponent:0 animated:YES];
    selectYear.inputView = yearPicker;
    
    selectYear.text = [NSString stringWithFormat:@"%d",selectedYear];
    selectYear.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown.png"]];
    selectYear.rightViewMode = UITextFieldViewModeAlways;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePicker)];
    doneButton.tintColor = [UIColor blackColor];
    [toolBar setItems:[NSArray arrayWithObjects:space ,doneButton, nil]];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
    [settingsButton sizeToFit];
    [settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    selectYear.inputAccessoryView = toolBar;
    
    containerTableView.backgroundColor = [UIColor clearColor];
    containerTableView.backgroundView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchVisitListByYear:selectedYear Country:self.country];
}

-(void)fetchVisitListByYear:(int)year Country:(NSString*)countryName
{
    NSError *error = nil;
    
    NSDate *startingDate = [NSDate firstDateOfYear:year];
    NSDate *endingDate = [NSDate firstDateOfYear:(year + 1)];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date >= %@ AND SELF.date < %@ AND SELF.country LIKE %@", startingDate, endingDate, countryName];
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
            self.gllVisitList = fetchedResult;
        }
    }
    else
    {
        self.gllVisitList = nil;
    }
}

-(void)settingsButtonAction
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)hidePicker
{
    [self.gllVisitList removeAllObjects];
    [selectYear resignFirstResponder];
    [self fetchVisitListByYear:selectedYear Country:self.country];
    [containerTableView reloadData];
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
    return self.gllVisitList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    CountryVisitDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[CountryVisitDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    GLLVisit *visit = [self.gllVisitList objectAtIndex:indexPath.row];
    
    if(visit.hasPhoto.boolValue)
    {
        cell.attachmentImageView.image = [UIImage imageNamed:@"attachmentIcon.png"];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy";
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:visit.date]];
    cell.cityCountryLabel.text = [NSString stringWithFormat:@"%@, %@",visit.city,visit.country];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(yearPicker == pickerView)
    {
        selectedYear = kBaseYear + row;
        selectYear.text = [NSString stringWithFormat:@"%d", selectedYear];
    }
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[NSDate date] year] - kBaseYear + 1;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [yearPicker selectRow:(selectedYear - kBaseYear) inComponent:0 animated:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
