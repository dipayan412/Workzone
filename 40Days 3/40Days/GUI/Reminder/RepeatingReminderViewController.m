//
//  RepeatingReminderViewController.m
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RepeatingReminderViewController.h"
#import "AppData.h"

@interface RepeatingReminderViewController ()

@end

@implementation RepeatingReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView.contentSize = contentView.frame.size;
    [scrollView addSubview:contentView];
    
    self.title = kAppTitle;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    
    NSArray *workingDays = [AppData getReminderDays];
    
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
    
    [self.view addSubview:timeSelectonView];
    [self.view addSubview:dateSelectionView];
    
    dateSelectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    timeSelectonView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    
    CGRect frame = timeSelectonView.frame;
    frame.origin.y = self.view.bounds.size.height;
    timeSelectonView.frame = frame;
    dateSelectionView.frame = frame;
    
    NSMutableArray *hoursAMModeArray = [[NSMutableArray alloc] init];
	for (int i=1; i<=12; i++)
    {
		[hoursAMModeArray addObject:[NSString stringWithFormat:@"%d", i]];
	}
    
	hoursPickerDateAMMode = [[NSArray alloc] initWithArray:hoursAMModeArray];
	[hoursAMModeArray release];
    
	NSMutableArray *amPMModesArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [amPMModesArray addObject:@"AM"];
    [amPMModesArray addObject:@"PM"];
    
	amPMPickerData = [[NSArray alloc] initWithArray:amPMModesArray];
	[amPMModesArray release];
    
    NSMutableArray *minutesArray = [[NSMutableArray alloc] init];
    
	for (int i=0; i<60; i++)
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
	
	minutesPickerData = [[NSArray alloc] initWithArray:minutesArray];
	[minutesArray release];
    
    [self updateButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self updateReminderDays];
}

-(void)updateReminderDays
{
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
    
    [AppData setReminderDays:[NSArray arrayWithArray:workingDays]];
    [workingDays release];
}

#pragma mark -
#pragma mark PickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [hoursPickerDateAMMode objectAtIndex:row];
    }
    else if (component == 1)
    {
        return [minutesPickerData objectAtIndex:row];
    }
    else
    {
        return [amPMPickerData objectAtIndex:row];
    }
    
	return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0)
    {
        return [hoursPickerDateAMMode count];
    }
    else if (component == 1)
    {
        return [minutesPickerData count];
    }
    else
    {
        return [amPMPickerData count];
    }
	return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50;
}


- (IBAction)selectDate:(id)sender
{
    [self showInputView:dateSelectionView];
    
    if([AppData getRepeatingReminderDate])
    {
        datePicker.date = [AppData getRepeatingReminderDate];
    }
}

- (IBAction)selectTime:(id)sender
{
    [self showInputView:timeSelectonView];
    
    NSArray *pickerSettings = [self getInitialPickerValuesFromTime:[AppData getRepeatingReminderTime]];
    
    for (NSInteger i = 0; i<[pickerSettings count]; i++)
    {
        [timePicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
    }
}

- (IBAction)createReminder:(id)sender
{
    [AppData setIsRepeatingReminderCreated:YES];
    
    [self updateButtons];
}

- (IBAction)cancelReminder:(id)sender
{
    [AppData setIsRepeatingReminderCreated:NO];
    
    [self updateButtons];
}

- (IBAction)dateSelectionDone:(id)sender
{
    [self hideInputView:dateSelectionView];
    
    [AppData setRepeatingReminderDate:datePicker.date];
}

- (IBAction)timeSelectionDone:(id)sender
{
    [self hideInputView:timeSelectonView];
    
    [AppData setRepeatingReminderTime:[self convertPickerDataToTimeFromView:timePicker]];
}

-(void)updateButtons
{
    if([AppData isRepeatingReminderCreated])
    {
        createReminderButton.enabled = NO;
        [createReminderButton setBackgroundImage:[UIImage imageNamed:@"disabled_button.png"] forState:UIControlStateNormal];
        
        cancelReminderButton.enabled = YES;
        [cancelReminderButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateNormal];
    }
    else
    {
        createReminderButton.enabled = YES;
        [createReminderButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateNormal];
        
        cancelReminderButton.enabled = NO;
        [cancelReminderButton setBackgroundImage:[UIImage imageNamed:@"disabled_button.png"] forState:UIControlStateNormal];
    }
}

-(void)showInputView:(UIView*)view
{
    [self.view bringSubviewToFront:view];
    
    view.frame = CGRectMake(0, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    view.frame = CGRectMake(0, self.view.frame.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)hideInputView:(UIView*)view
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    view.frame = CGRectMake(0, self.view.bounds.size.height, dateSelectionView.frame.size.width, dateSelectionView.frame.size.height);;
    
    [UIView commitAnimations];
}

- (NSArray*) getInitialPickerValuesFromTime:(NSNumber*)time
{
	if ([time intValue]==-1)
    {
		NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
																  fromDate:[NSDate date]];
		[comps setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
		time = [NSNumber numberWithDouble:((-1.0/60.0)*[beginningOfDay timeIntervalSinceNow])];
	}
	
	int hours = floor([time intValue]/60.0);
    
	int minutes = ([time intValue] - hours * 60);
    
	if (hours==24)
    {
        return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
    }
    else
    {
        if (hours == 12)
        { //(hours == 0)
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
        }
        else if (hours < 12)
        {
            //(hours <=12)
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:(hours-1)], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
        }
        else
        {
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:(hours-13)], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
        }
    }
}

//picker did select row

- (NSNumber*) convertPickerDataToTimeFromView:(UIPickerView*)pickerView
{
	int hoursValue = 0;
    
	hoursValue = [[hoursPickerDateAMMode objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
    if ([pickerView selectedRowInComponent:2] == 1)
    {
        hoursValue += 12;
        if (hoursValue == 24)
        {
            hoursValue = 12;
        }
    }
    else if([pickerView selectedRowInComponent:2] == 0)
    {
        if (hoursValue==12)
        {
            hoursValue = 24;
        }
    }
	
	int minutesValue = [[minutesPickerData objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
	return [NSNumber numberWithInt:(hoursValue*60 + minutesValue)];
}

@end
