//
//  SetWorkDaysViewController.m
//  MyOvertime
//
//  Created by Ashif on 1/5/13.
//
//

#import "SetWorkDaysViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsTemplateViewController.h"
#import "SettingsDayTemplate.h"
#import "MyOvertimeAppDelegate.h"

#define docPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SetWorkDaysViewController ()

- (NSString*) convertPeriodToString:(NSNumber*)period;
- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period;

@end

@implementation SetWorkDaysViewController

@synthesize workDaysCell;
@synthesize settingsDictionary;

@synthesize settings;

@synthesize mondayCheckbox, tuesdayCheckbox, wednesdayCheckbox, thursdayCheckbox, fridayCheckbox, saturdayCheckbox, sundayCheckbox;

@synthesize mondayTemplateButton, tuesdayTemplateButton, wednesdayTemplateButton, thursdayTemplateButton, fridayTemplateButton, saturdayTemplateButton, sundayTemplateButton;

@synthesize offsetSelectView, offsetSelectPicker, breakSelectView, breakSelectPicker, hoursPickerData, minutesPickerData;

@synthesize monOffsetLabel, tueOffsetLabel, wedOffsetLabel, thuOffsetLabel, friOffsetLabel, satOffsetLabel, sunOffsetLabel;

@synthesize monBreakLabel, tueBreakLabel, wedBreakLabel, thuBreakLabel, friBreakLabel, satBreakLabel, sunBreakLabel;

@synthesize monOffsetValue, tueOffsetValue, wedOffsetValue, thuOffsetValue, friOffsetValue, satOffsetValue, sunOffsetValue;

@synthesize monbreakValue, tuebreakValue, wedbreakValue, thubreakValue, fribreakValue, satbreakValue, sunbreakValue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reloadFetchedResults:(NSNotification*)note
{
    NSLog(@"Underlying data changed ... refreshing!");
    
    [self fetchSettings];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFetchedResults:)
                                                 name:@"iCloudDataChanged"
                                               object:[[UIApplication sharedApplication] delegate]];
    
    NSMutableArray *hoursArray = [[NSMutableArray alloc] initWithCapacity:1];
	for (int i=0; i<=23; i++)
    {
		[hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
	}
	self.hoursPickerData = hoursArray;
	[hoursArray release];
    
    self.title = NSLocalizedString(@"SETTINGS_SET_WORK_DAYS", nil);
    
//    workDaysCell.backgroundColor = [UIColor clearColor];
    workDaysCell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    workDaysCell.opaque = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 300, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.workDaysCell.contentView addSubview:label];
    
    weekDay = - 1;
    
    [self fetchSettings];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
    [ self updateMinutesForActiveInterval ];
    
	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
	
    self.monOffsetValue = [self.settingsDictionary objectForKey:@"MonOffset"];
    if(!monOffsetValue)
    {
        self.monOffsetValue = [NSNumber numberWithInt:480];
    }
	monOffsetLabel.text = [self convertPeriodToString:monOffsetValue];
    
    self.tueOffsetValue = [self.settingsDictionary objectForKey:@"TueOffset"];
    if(!tueOffsetValue)
    {
        self.tueOffsetValue = [NSNumber numberWithInt:480];
    }
	tueOffsetLabel.text = [self convertPeriodToString:tueOffsetValue];
    
    self.wedOffsetValue = [self.settingsDictionary objectForKey:@"WedOffset"];
    if(!wedOffsetValue)
    {
        self.wedOffsetValue = [NSNumber numberWithInt:480];
    }
	wedOffsetLabel.text = [self convertPeriodToString:wedOffsetValue];
    
    self.thuOffsetValue = [self.settingsDictionary objectForKey:@"ThuOffset"];
    if(!thuOffsetValue)
    {
        self.thuOffsetValue = [NSNumber numberWithInt:480];
    }
	thuOffsetLabel.text = [self convertPeriodToString:thuOffsetValue];
    
    self.friOffsetValue = [self.settingsDictionary objectForKey:@"FriOffset"];
    if(!friOffsetValue)
    {
        self.friOffsetValue = [NSNumber numberWithInt:480];
    }
	friOffsetLabel.text = [self convertPeriodToString:friOffsetValue];
    
    self.satOffsetValue = [self.settingsDictionary objectForKey:@"SatOffset"];
    if(!satOffsetValue)
    {
        self.satOffsetValue =  [NSNumber numberWithInt:480];
    }
	satOffsetLabel.text = [self convertPeriodToString:satOffsetValue];
    
    self.sunOffsetValue = [self.settingsDictionary objectForKey:@"SunOffset"];
    if(!sunOffsetValue)
    {
        self.sunOffsetValue =  [NSNumber numberWithInt:480];
    }
	sunOffsetLabel.text = [self convertPeriodToString:sunOffsetValue];
    
	self.monbreakValue = [self.settingsDictionary objectForKey:@"Monbreak"];
    if(!monbreakValue)
    {
        self.monbreakValue = [NSNumber numberWithInt:60];
    }
	monBreakLabel.text = [self convertPeriodToString:monbreakValue];
    
    self.tuebreakValue = [self.settingsDictionary objectForKey:@"Tuebreak"];
    if(!tuebreakValue)
    {
        self.tuebreakValue = [NSNumber numberWithInt:60];
    }
	tueBreakLabel.text = [self convertPeriodToString:tuebreakValue];
    
    self.wedbreakValue = [self.settingsDictionary objectForKey:@"Wedbreak"];
    if(!wedbreakValue)
    {
        self.wedbreakValue = [NSNumber numberWithInt:60];
    }
	wedBreakLabel.text = [self convertPeriodToString:wedbreakValue];
    
    self.thubreakValue = [self.settingsDictionary objectForKey:@"Thubreak"];
    if(!thubreakValue)
    {
        self.thubreakValue = [NSNumber numberWithInt:60];
    }
	thuBreakLabel.text = [self convertPeriodToString:thubreakValue];
    
    self.fribreakValue = [self.settingsDictionary objectForKey:@"Fribreak"];
    if(!fribreakValue)
    {
        self.fribreakValue = [NSNumber numberWithInt:60];
    }
	friBreakLabel.text = [self convertPeriodToString:fribreakValue];
    
    self.satbreakValue = [self.settingsDictionary objectForKey:@"Satbreak"];
    if(!satbreakValue)
    {
        self.satbreakValue = [NSNumber numberWithInt:60];
    }
	satBreakLabel.text = [self convertPeriodToString:satbreakValue];
    
    self.sunbreakValue = [self.settingsDictionary objectForKey:@"Sunbreak"];
    if(!sunbreakValue)
    {
        self.sunbreakValue = [NSNumber numberWithInt:60];
    }
	sunBreakLabel.text = [self convertPeriodToString:sunbreakValue];
    
    NSArray *workingDays = [self.settingsDictionary objectForKey:@"workingDays"];

	for (NSNumber *wee in workingDays)
    {
		if ([wee intValue] == 2)
        {
			mondayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 3)
        {
			tuesdayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 4)
        {
			wednesdayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 5)
        {
			thursdayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 6)
        {
			fridayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 7)
        {
			saturdayCheckbox.selected = YES;
		}
        else if ([wee intValue] == 1)
        {
			sundayCheckbox.selected = YES;
		}
	}
    
    NSEnumerator *enumerator = [self.settings.settingsDayTemplates objectEnumerator];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    SettingsDayTemplate *item;
    while (item = [enumerator nextObject])
    {
        [items addObject:item];
    }
    
    for(SettingsDayTemplate *template in items)
    {
        /*
        if(template.day.intValue == Sunday)
        {
            sundayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else if (template.day.intValue == Monday)
        {
            mondayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else if (template.day.intValue == Tuesday)
        {
            tuesdayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else if (template.day.intValue == Wednesday)
        {
            wednesdayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else if (template.day.intValue == Thursday)
        {
            thursdayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else if (template.day.intValue == Friday)
        {
            fridayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
        else
        {
            saturdayTemplateCheckbox.selected = template.templateEnabled.boolValue;
        }
         */
        
        if(template.day.intValue == Sunday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [sundayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [sundayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else if (template.day.intValue == Monday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [mondayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [mondayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else if (template.day.intValue == Tuesday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [tuesdayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [tuesdayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else if (template.day.intValue == Wednesday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [wednesdayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [wednesdayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else if (template.day.intValue == Thursday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [thursdayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [thursdayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else if (template.day.intValue == Friday)
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [fridayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [fridayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
            if(template.schedule.timeSheets.count > 0)
            {
                [saturdayTemplateButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
            }
            else
            {
                [saturdayTemplateButton setImage:[UIImage imageNamed:@"goButtonDisabled.png"] forState:UIControlStateNormal];
            }
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveAllSettings];
    [super viewWillDisappear:animated];
}

- ( void ) updatePickersSelection
{
    NSArray * pickerSettings = [ self getInitialPickerValuesFromPeriod: [self getCurrnetDayOffsetValue] ];
    
	for( NSInteger i = 0; i < [ pickerSettings count ]; i++ )
		[ offsetSelectPicker selectRow: [ [ pickerSettings objectAtIndex: i ] intValue ]
                           inComponent: i
                              animated: NO
         ];
	
    //	pickerSettings = [ self getInitialPickerValuesFromPeriod: monbreakValue ];
    
    pickerSettings = [ self getInitialPickerValuesFromPeriod: [self getCurrnetDayBreakValue] ];
	
	for( NSInteger i = 0; i < [ pickerSettings count ]; i++ )
		[ breakSelectPicker selectRow: [ [ pickerSettings objectAtIndex: i ] intValue ]
                          inComponent: i
                             animated: NO
         ];
}

-(NSNumber*)getCurrnetDayOffsetValue
{
    NSNumber *number = [[NSNumber alloc] init];
    
    switch (offsetForDay)
    {
        case MonDayOffset:
            number = monOffsetValue;
            break;
            
        case TueDayOffset:
            number = tueOffsetValue;
            break;
            
        case WedOffset:
            number = wedOffsetValue;
            break;
            
        case ThuOffset:
            number = thuOffsetValue;
            break;
            
        case FriOffset:
            number = friOffsetValue;
            break;
            
        case SatOffset:
            number = satOffsetValue;
            break;
            
        case SunDayOffset:
            number = sunOffsetValue;
            break;
            
        default:
            break;
    }
    
    return number;
}


-(NSNumber*)getCurrnetDayBreakValue
{
    NSNumber *number = [[NSNumber alloc] init];
    
    switch (breakForDay)
    {
        case MonDayBreak:
            number = monbreakValue;
            break;
            
        case TueDayBreak:
            number = tuebreakValue;
            break;
            
        case WedBreak:
            number = wedbreakValue;
            break;
            
        case ThuBreak:
            number = thubreakValue;
            break;
            
        case FriBreak:
            number = fribreakValue;
            break;
            
        case SatBreak:
            number = satbreakValue;
            break;
            
        case SunBreak:
            number = sunbreakValue;
            break;
            
        default:
            break;
    }
    
    return number;
}

- ( void ) updateMinutesForActiveInterval
{
    NSMutableArray * minutesArray = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
    NSInteger timeInterval = [ self safeTimeInterval ];
    
	//	Changed by $TINGTONG
	for (int i=0; i<60; i+=timeInterval)
    {
		if (i<10)
        {
			[minutesArray addObject:[NSString stringWithFormat:@"0%d", i]];
		}
        else
        {
			[minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
		}
	}
	self.minutesPickerData = minutesArray;
	[minutesArray release];
}

- (IBAction) mondayCheckboxSelected:(id)sender
{
	UIButton *curButton = (UIButton*)sender;
	if (curButton.selected)
    {
		curButton.selected = NO;
	}
    else
    {
		curButton.selected = YES;
	}
    
    [self saveAllSettings];
}

-(IBAction)enableTemplateSelected:(id)sender
{
    UIButton *curButton = (UIButton*)sender;
	if (curButton.selected)
    {
		curButton.selected = NO;
	}
    else
    {
		curButton.selected = YES;
	}
    
    switch ([(UIButton *)sender tag])
    {
        case 301:
            weekDay = Monday;
            break;
            
        case 302:
            weekDay = Tuesday;
            break;
            
        case 303:
            weekDay = Wednesday;
            break;
            
        case 304:
            weekDay = Thursday;
            break;
            
        case 305:
            weekDay = Friday;
            break;
            
        case 306:
            weekDay = Saturday;
            break;
            
        case 307:
            weekDay = Sunday;
            break;
            
        default:
            break;
    }
    
    NSEnumerator *enumerator = [self.settings.settingsDayTemplates objectEnumerator];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    SettingsDayTemplate *item;
    while (item = [enumerator nextObject])
    {
        [items addObject:item];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@", [NSNumber numberWithInt:weekDay]];
    NSArray* filteredTemplate = [items filteredArrayUsingPredicate:predicate];
    
    SettingsDayTemplate *template = [filteredTemplate objectAtIndex:0];
    template.templateEnabled = [NSNumber numberWithBool:curButton.selected];
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = app.managedObjectContext;
    
    NSError *error;
    [managedObjectContext save:&error];
}

-(IBAction)showWorkDayTemplate:(id)sender
{
    switch ([(UIButton *)sender tag])
    {
        case 501:
            weekDay = Monday;
            break;
            
        case 502:
            weekDay = Tuesday;
            break;
            
        case 503:
            weekDay = Wednesday;
            break;
            
        case 504:
            weekDay = Thursday;
            break;
            
        case 505:
            weekDay = Friday;
            break;
            
        case 506:
            weekDay = Saturday;
            break;
            
        case 507:
            weekDay = Sunday;
            break;
            
        default:
            break;
    }
    
    NSEnumerator *enumerator = [self.settings.settingsDayTemplates objectEnumerator];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    SettingsDayTemplate *item;
    while (item = [enumerator nextObject])
    {
        [items addObject:item];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@", [NSNumber numberWithInt:weekDay]];
    NSArray* filteredTemplate = [items filteredArrayUsingPredicate:predicate];
    SettingsDayTemplate *template = nil;
    if(filteredTemplate.count > 0)
    {
        template = [filteredTemplate objectAtIndex:0];
    }
    
    SettingsTemplateViewController *setVC = [[SettingsTemplateViewController alloc] initWithNibName:@"SettingsTemplateViewController" bundle:nil];
    
    setVC.dayTemplate = template;
    
    [self.navigationController pushViewController:setVC animated:YES];
    [setVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return workDaysCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 343;
}

- (IBAction) showSelectOffsetView:(id)sender
{
    switch ([(UIButton *)sender tag])
    {
        case 101:
            offsetForDay = MonDayOffset;
            break;
            
        case 102:
            offsetForDay = TueDayOffset;
            break;
            
        case 103:
            offsetForDay = WedOffset;
            break;
            
        case 104:
            offsetForDay = ThuOffset;
            break;
            
        case 105:
            offsetForDay = FriOffset;
            break;
            
        case 106:
            offsetForDay = SatOffset;
            break;
            
        case 107:
            offsetForDay = SunDayOffset;
            break;
            
        default:
            break;
    }
    
    [ offsetSelectPicker reloadAllComponents ];
    [ self updatePickersSelection ];
    
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	offsetSelectView.frame = initialRect;
	[self.view.window addSubview:offsetSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 offsetSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];
}

- (IBAction) hideSelectOffsetView:(id)sender
{
    switch (offsetForDay)
    {
        case MonDayOffset:
            
            self.monOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            monOffsetLabel.text = [self convertPeriodToString:monOffsetValue];
            
            break;
            
        case TueDayOffset:
            
            self.tueOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            tueOffsetLabel.text = [self convertPeriodToString:tueOffsetValue];
            
            break;
            
        case WedOffset:
            
            self.wedOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            wedOffsetLabel.text = [self convertPeriodToString:wedOffsetValue];
            
            break;
            
        case ThuOffset:
            
            self.thuOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            thuOffsetLabel.text = [self convertPeriodToString:thuOffsetValue];
            
            break;
            
        case FriOffset:
            
            self.friOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            friOffsetLabel.text = [self convertPeriodToString:friOffsetValue];
            
            break;
            
        case SatOffset:
            
            self.satOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            satOffsetLabel.text = [self convertPeriodToString:satOffsetValue];
            
            break;
            
        case SunDayOffset:
            
            self.sunOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
            sunOffsetLabel.text = [self convertPeriodToString:sunOffsetValue];
            
            break;
            
        default:
            break;
    }
    //	self.offsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
    //	offsetLabel.text = [self convertPeriodToString:offsetValue];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 offsetSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [offsetSelectView removeFromSuperview];
					 }];
	[ self saveAllSettings ];
}

- (IBAction) showSelectBreakView:(id)sender
{
    switch ([(UIButton *)sender tag])
    {
        case 201:
            breakForDay = MonDayBreak;
            break;
            
        case 202:
            breakForDay = TueDayBreak;
            break;
            
        case 203:
            breakForDay = WedBreak;
            break;
            
        case 204:
            breakForDay = ThuBreak;
            break;
            
        case 205:
            breakForDay = FriBreak;
            break;
            
        case 206:
            breakForDay = SatBreak;
            break;
            
        case 207:
            breakForDay = SunBreak;
            break;
            
        default:
            break;
    }
    
    [ breakSelectPicker reloadAllComponents ];
    [ self updatePickersSelection ];
    
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	breakSelectView.frame = initialRect;
	[self.view.window addSubview:breakSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 breakSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];
}

- (IBAction) hideSelectBreakView:(id)sender
{
	switch (breakForDay)
    {
        case MonDayBreak:
            
            self.monbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            monBreakLabel.text = [self convertPeriodToString:monbreakValue];
            
            break;
            
        case TueDayBreak:
            
            self.tuebreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            tueBreakLabel.text = [self convertPeriodToString:tuebreakValue];
            
            break;
            
        case WedBreak:
            
            self.wedbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            wedBreakLabel.text = [self convertPeriodToString:wedbreakValue];
            
            break;
            
        case ThuBreak:
            
            self.thubreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            thuBreakLabel.text = [self convertPeriodToString:thubreakValue];
            
            break;
            
        case FriBreak:
            
            self.fribreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            friBreakLabel.text = [self convertPeriodToString:fribreakValue];
            
            break;
            
        case SatBreak:
            
            self.satbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            satBreakLabel.text = [self convertPeriodToString:satbreakValue];
            
            break;
            
        case SunBreak:
            
            self.sunbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
            sunBreakLabel.text = [self convertPeriodToString:sunbreakValue];
            
            break;
            
        default:
            break;
    }
    
    //	self.breakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
    //	breakLabel.text = [self convertPeriodToString:breakValue];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 breakSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [breakSelectView removeFromSuperview];
					 }];
	
	[ self saveAllSettings ];
}

#pragma mark -
#pragma mark PickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (pickerView == offsetSelectPicker)
    {
		switch (offsetForDay)
        {
            case MonDayOffset:
                
                self.monOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                monOffsetLabel.text = [self convertPeriodToString:monOffsetValue];
                
                break;
                
            case TueDayOffset:
                
                self.tueOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                tueOffsetLabel.text = [self convertPeriodToString:tueOffsetValue];
                
                break;
                
            case WedOffset:
                
                self.wedOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                wedOffsetLabel.text = [self convertPeriodToString:wedOffsetValue];
                
                break;
                
            case ThuOffset:
                
                self.thuOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                thuOffsetLabel.text = [self convertPeriodToString:thuOffsetValue];
                
                break;
                
            case FriOffset:
                
                self.friOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                friOffsetLabel.text = [self convertPeriodToString:friOffsetValue];
                
                break;
                
            case SatOffset:
                
                self.satOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                satOffsetLabel.text = [self convertPeriodToString:satOffsetValue];
                
                break;
                
            case SunDayOffset:
                
                self.sunOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
                sunOffsetLabel.text = [self convertPeriodToString:sunOffsetValue];
                
                break;
                
            default:
                break;
        }
	}
    else
    {
        switch (breakForDay)
        {
            case MonDayBreak:
                
                self.monbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                monBreakLabel.text = [self convertPeriodToString:monbreakValue];
                
                break;
                
            case TueDayBreak:
                
                self.tuebreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                tueBreakLabel.text = [self convertPeriodToString:tuebreakValue];
                
                break;
                
            case WedBreak:
                
                self.wedbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                wedBreakLabel.text = [self convertPeriodToString:wedbreakValue];
                
                break;
                
            case ThuBreak:
                
                self.thubreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                thuBreakLabel.text = [self convertPeriodToString:thubreakValue];
                
                break;
                
            case FriBreak:
                
                self.fribreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                friBreakLabel.text = [self convertPeriodToString:fribreakValue];
                
                break;
                
            case SatBreak:
                
                self.satbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                satBreakLabel.text = [self convertPeriodToString:satbreakValue];
                
                break;
                
            case SunBreak:
                
                self.sunbreakValue = [self convertPickerDataToPeriodFromView:breakSelectPicker];
                sunBreakLabel.text = [self convertPeriodToString:sunbreakValue];
                
                break;
                
            default:
                break;
        }
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0)
    {
		return [hoursPickerData objectAtIndex:row];
	}
    else
    {
		return [minutesPickerData objectAtIndex:row];
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0)
    {
		return [hoursPickerData count];
	}
    else
    {
		return [minutesPickerData count];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50;
}

#pragma mark -
#pragma mark Time Converting functionality

- (NSString*) convertPeriodToString:(NSNumber*)period
{
	int hours = floor([period intValue]/60.0);
	int minutes = [period intValue] - hours * 60;
	
	if (minutes < 10)
    {
		return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
	}
    else
    {
		return [NSString stringWithFormat:@"%d:%d", hours, minutes];
	}
}

- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView
{	
	int hoursValue = [[self.hoursPickerData objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
	int minutesValue = [[self.minutesPickerData objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
	
	return [NSNumber numberWithInt:(hoursValue*60 + minutesValue)];
}

- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period
{
	int hours = floor([period intValue]/60.0);
	int minutes = ([period intValue] - hours * 60)/[self safeTimeInterval];
	
	return [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
}


#pragma mark -
#pragma mark Bind data to properties
- (void) bindDataToProperties
{    
    [self.settingsDictionary setObject:monOffsetValue forKey:@"MonOffset"];
	[self.settingsDictionary setObject:monbreakValue forKey:@"Monbreak"];
    
    [self.settingsDictionary setObject:tueOffsetValue forKey:@"TueOffset"];
	[self.settingsDictionary setObject:tuebreakValue forKey:@"Tuebreak"];
    
    [self.settingsDictionary setObject:wedOffsetValue forKey:@"WedOffset"];
	[self.settingsDictionary setObject:wedbreakValue forKey:@"Wedbreak"];
    
    [self.settingsDictionary setObject:thuOffsetValue forKey:@"ThuOffset"];
	[self.settingsDictionary setObject:thubreakValue forKey:@"Thubreak"];
    
    [self.settingsDictionary setObject:friOffsetValue forKey:@"FriOffset"];
	[self.settingsDictionary setObject:fribreakValue forKey:@"Fribreak"];
    
    [self.settingsDictionary setObject:satOffsetValue forKey:@"SatOffset"];
	[self.settingsDictionary setObject:satbreakValue forKey:@"Satbreak"];
    
    [self.settingsDictionary setObject:sunOffsetValue forKey:@"SunOffset"];
	[self.settingsDictionary setObject:sunbreakValue forKey:@"Sunbreak"];
	
	NSMutableArray *workingDays = [[NSMutableArray alloc] initWithCapacity:0];
	if (sundayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:1]];
	}
	if (mondayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:2]];
	}
	if (tuesdayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:3]];
	}
	if (wednesdayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:4]];
	}
	if (thursdayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:5]];
	}
	if (fridayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:6]];
	}
	if (saturdayCheckbox.selected)
    {
		[workingDays addObject:[NSNumber numberWithInt:7]];
	}
	if ([workingDays count]==0)
    {
		[workingDays addObject:[NSNumber numberWithInt:2]];
	}
	
	[self.settingsDictionary setObject:workingDays forKey:@"workingDays"];
	[workingDays release];
}

- ( NSInteger ) safeTimeInterval
{
    NSInteger timeInterval = [ [ self.settingsDictionary objectForKey: @"timeDialInterval" ] intValue ];
    
    if( ( timeInterval != 1 ) && ( timeInterval != 5 ) && ( timeInterval != 15 ) && ( timeInterval != 3 ) )
        timeInterval = 1;
    
    return timeInterval;
}

-(void)saveAllSettings
{
    [self bindDataToProperties];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	[self.settingsDictionary writeToFile:path atomically:YES];
}

-(void)fetchSettings
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = app.managedObjectContext;
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSError *err = nil;
    NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults1 == nil)
    {
        
    }
    else
    {
        self.settings = [mutableFetchResults1 objectAtIndex:0];
    }
}


@end
