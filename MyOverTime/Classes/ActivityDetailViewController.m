//
//  ActivityDetailViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+FormScroll.h"
#import "GlobalFunctions.h"		//	$TING CODE

@implementation ActivityDetailViewController

@synthesize settingsDictionary;
@synthesize activityTitle, flatModeSwitch, allowanceHours;
@synthesize activityDetailCell;
@synthesize currentActivity;
@synthesize managedObjectContext;
@synthesize offsetSelectPicker;
@synthesize offsetSelectView;

@synthesize estimateModePlus, estimateModeMinus;
@synthesize offsetButton, offsetLabel, defaultButton;
@synthesize selectOffsetButton;

@synthesize isNew;

@synthesize offset;

@synthesize overTimeReducer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
	self.navigationItem.title = NSLocalizedString(@"ACTIVITY_DETAIL_TITLE", @"");
	
	activityTitle.text = currentActivity.activityTitle;
	flatModeSwitch.on = [currentActivity.flatMode boolValue];
    overTimeReducer.on = [currentActivity.overtimeReduce boolValue];
    
	estimateModePlus.selected = NO;
	estimateModeMinus.selected = NO;
	
//Meghan
    //NSLog(@"Float Value : %0.2f",[currentActivity.allowance floatValue]);
    
    float allowancehrs = [[NSString stringWithFormat:@"%0.2f",[currentActivity.allowance floatValue]] floatValue];
    
    int hours = floorf(allowancehrs);
    float minutes = ((allowancehrs-hours)/100)*60;
    
   // NSString *allowancehrsDecimal = [NSString stringWithFormat:@"Final Allowancehrs - %0.2f",hours+minutes];
    
    allowanceHours.text = [NSString stringWithFormat:@"%0.2f",(hours+minutes)];
	//allowanceHours.text = [NSString stringWithFormat:@"%0.2f",[currentActivity.allowance floatValue]];		
    
    
    //allowanceHours.text = [currentActivity.allowance stringValue];		//	$TING COMMENT
//Meghan
    //	float timeToShow = [GlobalFunctions allowanceHoursToField:[currentActivity.allowance floatValue]];
//	allowanceHours.text = [NSString stringWithFormat:@"%.2f", timeToShow];
	
	if ([currentActivity.estimateMode boolValue])
    {
		estimateModePlus.selected = YES;
	}
    else
    {
		estimateModeMinus.selected = YES;
	}
    
    // Ashif
    
    [activityDetailCell.layer setCornerRadius:7.0f];
    [activityDetailCell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [activityDetailCell.layer setBorderWidth:1.0f];
    
    activityDetailCell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    
    [self.view addSubview:activityDetailCell];
    
    if(flatModeSwitch.on)
    {
        activityDetailCell.frame = CGRectMake(9, 10, activityDetailCell.frame.size.width, 334);
    }
    else
    {   
        activityDetailCell.frame = CGRectMake(9, 10, activityDetailCell.frame.size.width, 185);
    }
    
    defaultButton.selected = NO;
    offsetButton.selected = NO;
    
    if(currentActivity.useDefault.boolValue)
    {
        defaultButton.selected = YES;
        flatTimeSetToDefault = YES;
        
        offsetLabel.alpha = 1.0f;
        offsetLabel.textColor = [UIColor blackColor];
        selectOffsetButton.enabled = YES;
        selectOffsetButton.alpha = 1.0f;
    }
    else
    {
        offsetButton.selected = YES;
        flatTimeSetToDefault = NO;
        
        offsetLabel.alpha = 0.5f;
        offsetLabel.textColor = [UIColor lightGrayColor];
        selectOffsetButton.enabled = NO;
        selectOffsetButton.alpha = 0.5f;
    }
    
    amount = currentActivity.amount.floatValue;
    amountField.text = [NSString stringWithFormat:@"%0.2f", amount];
    
    showAmountSwitch.on = currentActivity.showAmount.boolValue;
    if(showAmountSwitch.on)
    {
        amountField.enabled = YES;
        amountField.alpha = 1.0f;
        amountField.textColor = [UIColor blackColor];
    }
    else
    {
        amountField.enabled = NO;
        amountField.alpha = 0.5f;
        amountField.textColor = [UIColor lightGrayColor];
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [super viewWillAppear:YES];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.offset = currentActivity.offsetValue;
    
    offsetLabel.text = [self convertPeriodToString:self.offset];
	
	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
//	self.tableView.backgroundView = myImageView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	[myImageView release];
}

- ( NSInteger ) safeTimeInterval
{
    NSInteger timeInterval = [ [ self.settingsDictionary objectForKey: @"timeDialInterval" ] intValue ];
    
    if( ( timeInterval != 1 ) && ( timeInterval != 5 ) && ( timeInterval != 15 ) && ( timeInterval != 3 ) )
        timeInterval = 1;
    
    return timeInterval;
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (isNew)
    {
		currentActivity.activityTitle = activityTitle.text;
		currentActivity.flatMode = [NSNumber numberWithBool:flatModeSwitch.on];

		currentActivity.allowance = [NSNumber numberWithFloat:[allowanceHours.text floatValue]];
	
        if (estimateModePlus.selected)
        {
			currentActivity.estimateMode = [NSNumber numberWithBool:YES];
		}
        else
        {
			currentActivity.estimateMode = [NSNumber numberWithBool:NO];
		}
        
        currentActivity.useDefault = [NSNumber numberWithBool:flatTimeSetToDefault];
        
        currentActivity.offsetValue = [NSNumber numberWithInt:self.offset.intValue];
        
        currentActivity.showAmount = [NSNumber numberWithBool:showAmountSwitch.on];
        currentActivity.amount = [NSNumber numberWithFloat:amount];
        
		NSError *error;
		if (![managedObjectContext save:&error])
        {
			// Handle the error.
		}			
	}
    else
    {
		
		BOOL isAnyChanges;
		if (![currentActivity.activityTitle isEqual:activityTitle.text])
        {
			isAnyChanges = YES;
		}
        else if (![currentActivity.flatMode isEqual:[NSNumber numberWithBool:flatModeSwitch.on]])
        {
			isAnyChanges = YES;
		}
        else if ([currentActivity.overtimeReduce isEqual:[NSNumber numberWithBool:overTimeReducer.on]])
        {
            isAnyChanges = YES;
        }
        else if (![currentActivity.estimateMode isEqual:[NSNumber numberWithBool:estimateModePlus.selected]])
        {
			isAnyChanges = YES;
//		} else if (![currentActivity.allowance isEqual:[NSNumber numberWithFloat:[GlobalFunctions allowanceHoursFromField:[allowanceHours.text floatValue]]]]) {
		}
        else if (![currentActivity.allowance isEqual:[NSNumber numberWithFloat:[allowanceHours.text floatValue]]])
        {
			isAnyChanges = YES;
		}
        
        else if ([currentActivity.offsetValue isEqual:self.offset])
        {
            isAnyChanges = YES;
        }
        
        else if ([currentActivity.useDefault isEqual:[NSNumber numberWithBool:flatTimeSetToDefault]])
        {
            isAnyChanges = YES;
        }
        else if ([currentActivity.showAmount isEqual:[NSNumber numberWithBool:showAmountSwitch.on]])
        {
            isAnyChanges = YES;
        }
        else if ([currentActivity.amount isEqual:[NSNumber numberWithFloat:amount]])
        {
            isAnyChanges = YES;
        }
		if (isAnyChanges)
        {
			currentActivity.isEnabled = [NSNumber numberWithBool:NO];
			int currentSubsequence = [currentActivity.subSequence intValue];
			currentActivity.subSequence = [NSNumber numberWithInt:-1];
			
			NSError *error;
			if (![managedObjectContext save:&error])
            {
				// Handle the error.
			}			
			
			self.currentActivity = (Activity*)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
			currentActivity.isEnabled = [NSNumber numberWithBool:YES];
			currentActivity.subSequence = [NSNumber numberWithInt:currentSubsequence];
			currentActivity.activityTitle = activityTitle.text;
			currentActivity.flatMode = [NSNumber numberWithBool:flatModeSwitch.on];
            currentActivity.overtimeReduce = [NSNumber numberWithBool:overTimeReducer.on];
//			currentActivity.allowance = [NSNumber numberWithFloat:[GlobalFunctions allowanceHoursFromField:[allowanceHours.text floatValue]]];
            
            //Added by MEGHAN
          //  NSNumber *allowancehrs = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%0.2f",[allowanceHours.text floatValue]] floatValue]];
            float allowancehrs = [[NSString stringWithFormat:@"%0.2f",[allowanceHours.text floatValue]] floatValue];
            
            int hours = floorf(allowancehrs);
            float minutes = ((allowancehrs-hours)/60)*100;
            
            float allowancehrsDecimal = [[NSString stringWithFormat:@"%0.2f",(hours+minutes)] floatValue];
            //NSLog(@"Allowance hours input : %0.2f",allowancehrsDecimal);
            
            currentActivity.allowance = [NSNumber numberWithFloat:allowancehrsDecimal];
          
            
            //  currentActivity.allowance = [NSNumber numberWithFloat:[allowanceHours.text floatValue]];
            //Meghan
			if (estimateModePlus.selected)
            {
				currentActivity.estimateMode = [NSNumber numberWithBool:YES];
			}
            else
            {
				currentActivity.estimateMode = [NSNumber numberWithBool:NO];
			}
            
            currentActivity.useDefault = [NSNumber numberWithBool:flatTimeSetToDefault];
            
            currentActivity.offsetValue = [NSNumber numberWithInt:self.offset.intValue];
            
            currentActivity.showAmount = [NSNumber numberWithBool:showAmountSwitch.on];
            currentActivity.amount = [NSNumber numberWithFloat:amount];
			
			if (![managedObjectContext save:&error] && [currentActivity.activityTitle length]>0)
            {
				// Handle the error.
			}						
		}
	}
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

//	$TINGTONG CODE START FOR ITEM 2
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField == allowanceHours)
    {
		NSString *oldString = textField.text;
		NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];

		if ([newString length] > [oldString length])
        {
			NSRange pointRange = [newString rangeOfString:@"."];
			if (pointRange.length > 0)
            {
				//	in the case of suffix after dot is longer than 2 characters
				if ([newString length]-1 > pointRange.location + 2)
					return NO;
				//	in the case of .7 .8 .9
				if ([newString length]-1 == pointRange.location+1)
                {
					int last_number = [[newString substringFromIndex:pointRange.location+1] intValue];
					if (last_number > 5)
						return NO;
				}
			}
		}
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == amountField)
    {
        [self.view scrollToView:amountField];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == amountField)
    {
        [self.view scrollToY:0];
        
        NSString *value = [amountField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        NSLog(@"value %@", value);
        amount = value.floatValue;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:[NSLocale currentLocale]];
        NSNumber *tmp = [[NSNumber alloc] initWithFloat:amount];
        
        NSLog(@"format %@", [numberFormatter stringFromNumber:tmp]);
    }
    
    [textField resignFirstResponder];
}
//	$TINGTONG CODE END
	
#pragma mark -
#pragma mark Checkboxes logic

- (IBAction) changeSelectedCheckbox:(id)sender
{
	estimateModePlus.selected = NO;
	estimateModeMinus.selected = NO;
	UIButton *currentButton = (UIButton*)sender;
	currentButton.selected = YES;
}

-(IBAction)changeDefaultSelectedCheckbox:(id)sender
{
    defaultButton.selected = NO;
	offsetButton.selected = NO;
	UIButton *currentButton = (UIButton*)sender;
	currentButton.selected = YES;
    
    if(currentButton == defaultButton)
    {
        flatTimeSetToDefault = currentButton.selected;
        
        offsetLabel.textColor = [UIColor blackColor];
        offsetLabel.alpha = 1.0f;
        selectOffsetButton.enabled = YES;
        selectOffsetButton.alpha = 1.0f;

    }
    else
    {
        flatTimeSetToDefault = NO;
        
        offsetLabel.textColor = [UIColor lightGrayColor];
        offsetLabel.alpha = 0.5f;
        selectOffsetButton.enabled = NO;
        selectOffsetButton.alpha = 0.5f;
    }
}

- (IBAction)flatModeSwitchValueChanged:(id)sender
{
    if(flatModeSwitch.on)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
        [UIView setAnimationDuration:0.4];
        
        activityDetailCell.frame = CGRectMake(9, 10, activityDetailCell.frame.size.width, 334);

        [UIView commitAnimations];
        
    }
    if(!flatModeSwitch.on)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        
        activityDetailCell.frame = CGRectMake(9, 10, activityDetailCell.frame.size.width, 185);
        
        [UIView commitAnimations];
    }
}

-(IBAction)overTimeReducerValueChanged:(id)sender
{
    
}

- (IBAction)showAmountStateChanged:(id)sender
{
    if(showAmountSwitch.on)
    {
//        amountHidingView.alpha = 0.0f;
        
        amountField.textColor = [UIColor blackColor];
        amountField.alpha = 1.0f;
        amountField.enabled = YES;
    }
    else
    {
//        amountHidingView.alpha = 0.5f;
        
        amountField.textColor = [UIColor lightGrayColor];
        amountField.alpha = 0.5f;
        amountField.enabled = NO;
    }
}

- (IBAction) showSelectOffsetView:(id)sender
{
    [ offsetSelectPicker reloadAllComponents ];
    
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
    self.offset = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
    offsetLabel.text = [self convertPeriodToString:offset];
    
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 offsetSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished){
						 [offsetSelectView removeFromSuperview];
					 }];
}

#pragma mark -
#pragma mark PickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    self.monOffsetValue = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
//    monOffsetLabel.text = [self convertPeriodToString:monOffsetValue];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0)
    {
		return [NSString stringWithFormat:@"%d", row];
	}
    else
    {
		return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0)
    {
		return 1000;
	}
    else
    {
		return (60 / [self safeTimeInterval]);
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
	int hours = floor([period intValue] / 60.0);
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
	int hoursValue = [pickerView selectedRowInComponent:0];
	int minutesValue = [pickerView selectedRowInComponent:1] * [self safeTimeInterval];
	
	return [NSNumber numberWithInt:(hoursValue * 60 + minutesValue)];
}

- (void) hideKeyboard
{
    [self.view scrollToY:0];
    
    [allowanceHours resignFirstResponder];
    [amountField resignFirstResponder];
    [activityTitle resignFirstResponder];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[activityTitle release];
	[allowanceHours release];
	[flatModeSwitch release];
	
	[activityDetailCell release];
	
	[managedObjectContext release];
	[currentActivity release];
	
	[estimateModePlus release];
	[estimateModeMinus release];
    
    [offsetSelectPicker release];
    [offsetSelectView release];
	
    [super dealloc];
}

-(IBAction)testTapped:(id)sender
{
}


@end

