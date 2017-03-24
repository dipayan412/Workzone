//
//  CountryViewController.m
//  GeoLocationLogger
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "CountryViewController.h"
#import "GLLVisit.h"
#import "AppDelegate.h"
#import "CountryVisitDetailsViewController.h"
#import "SettingsViewController.h"
#import "NSDate+Extension.h"

@interface CountryViewController ()
{
    NSMutableArray *countryArray;
    
    int selectedYear;
    
    UIPickerView *yearPicker;
}

@property (nonatomic, retain) NSMutableArray *gllVisitList;

@end

@implementation CountryViewController

@synthesize gllVisitList;

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
    
    self.title = @"Countries";
    self.view.backgroundColor = kApplicationBackground;
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0f / 255.0f green:52.0f/255.0f blue:52.0f / 255.0f alpha:1.0f];
    }
    
    countryArray = [[NSMutableArray alloc] init];
    
    selectedYearView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"YearDropdownBG.png"]];
    
    selectedYear = [[NSDate date] year];
    
    selectYearTextField.text = [NSString stringWithFormat:@"%d",selectedYear];
    selectYearTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown.png"]];
    selectYearTextField.rightViewMode = UITextFieldViewModeAlways;
    
    yearPicker = [[UIPickerView alloc] init];
    yearPicker.delegate = self;
    [yearPicker selectRow:(selectedYear - kBaseYear) inComponent:0 animated:YES];
    
    selectYearTextField.inputView = yearPicker;
    
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
    
    selectYearTextField.inputAccessoryView = toolBar;
    
    containerTableView.backgroundColor = [UIColor clearColor];
    containerTableView.backgroundView = nil;
}

-(void)settingsButtonAction
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [countryArray removeAllObjects];
    
    [self fetchGllVisitByYear:selectedYear];
    [self getCountryArray];
    [containerTableView reloadData];
}

-(void)hidePicker
{
    [self.gllVisitList removeAllObjects];
    [countryArray removeAllObjects];
    [selectYearTextField resignFirstResponder];
    [self fetchGllVisitByYear:selectedYear];
    [self getCountryArray];
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
            self.gllVisitList = fetchedResult;
        }
    }
    else
    {
        self.gllVisitList = nil;
    }
}

-(void)getCountryArray
{
    for(int i = 0; i < gllVisitList.count; i++)
    {
        GLLVisit *visit = [gllVisitList objectAtIndex:i];
        NSLog(@"Country --> %@",visit.country);
        [countryArray addObject:visit.country];
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:countryArray];
    [countryArray removeAllObjects];
    [countryArray addObjectsFromArray:[orderedSet array]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return countryArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[CountryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *countryName = [countryArray objectAtIndex:indexPath.row];
    NSLog(@"countryName: %@",countryName);
    
    if([countryName isEqualToString:@"Bangladesh"])
    {
        cell.countryFlagImageView.image = [UIImage imageNamed:@"bangladesh_flag.png"];
    }
    else if([countryName isEqualToString:@"Spain"])
    {
        cell.countryFlagImageView.image = [UIImage imageNamed:@"spain_flag.png"];
    }
    else if([countryName isEqualToString:@"United States"])
    {
        cell.countryFlagImageView.image = [UIImage imageNamed:@"usa_flag.png"];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy";
    
    cell.countryNameLabel.text = countryName;
    cell.totalVisitLabel.text = [NSString stringWithFormat:@"Visits: %d",[self countVisitByCountry:countryName]];
    cell.lastVisitDateLabel.text = [NSString stringWithFormat:@"Last visit: %@",[df stringFromDate:[self lastVisitByCountry:countryName]]];
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if(gllVisitList.count > 0)
//    {
//        GLLVisit *gv = [gllVisitList objectAtIndex:indexPath.row];
//        
//        CountryVisitDetailsViewController *vc = [[CountryVisitDetailsViewController alloc] initWithNibName:@"CountryVisitDetailsViewController" bundle:nil City:gv.city Country:gv.country Date:gv.date];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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

-(int)countVisitByCountry:(NSString*)country
{
    NSError *error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.country LIKE %@", country];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedResult.count;
}

-(NSDate*)lastVisitByCountry:(NSString*)country
{
    NSError *error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.country LIKE %@", country];
    [fetchRequest setPredicate:predicate1];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor , nil]];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    GLLVisit *visit = nil;
    if(fetchedResult.count > 0)
    {
        visit = [fetchedResult lastObject];
    }
    return visit.date;
}

-(void)detailButtonActionWithIndexPath:(NSIndexPath *)indexpath
{
    NSLog(@"indexPath %d",indexpath.row);
    
    CountryVisitDetailsViewController *vc = [[CountryVisitDetailsViewController alloc] initWithNibName:@"CountryVisitDetailsViewController" bundle:nil Country:[countryArray objectAtIndex:indexpath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
