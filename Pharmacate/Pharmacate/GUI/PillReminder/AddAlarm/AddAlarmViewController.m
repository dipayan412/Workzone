//
//  AddAlarmViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/22/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "AddAlarmViewController.h"


@interface AddAlarmViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UITextField *startDateTextField;
    UITextField *endDateTextField;
    UITextField *startTimeTextField;
    UITextField *intervalTimeTextField;
    NSMutableDictionary *intervalDictionary;
    NSMutableDictionary *durationDictionary;
    NSMutableArray *suggestionArray;
    NSArray* sortedKeys;
    NSArray *sortedDurationArray;
    UITableView *suggestionTableView;
    int maxPage;
    int selectedIntervalTime;
    NSTimer *typeTimer;
}

@end

@implementation AddAlarmViewController

@synthesize productArray;
@synthesize diseaseArray;
@synthesize allergyArray;
@synthesize productAllergeyArray;
@synthesize isFromProductDetail;
@synthesize searchTextField;
@synthesize productId;
@synthesize productName;

-(void)loadView
{
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    maxPage = 20;
    suggestionArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);;
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 60);
    [postButton setTitleColor:themeColor forState:UIControlStateNormal];
    [postButton setTitle:NSLocalizedString(kPillReminderAlarmSubmitButton, nil) forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:postButton];
    [self.view addSubview:customNavigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.size.width, 0, [UIScreen mainScreen].bounds.size.width - 2 * backButton.frame.size.width, customNavigationBar.frame.size.height)];
    titleLabel.text = NSLocalizedString(kPillReminderAlarmTitle, nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [customNavigationBar addSubview:titleLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    [self.view addSubview:customNavigationBar];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, customNavigationBar.frame.origin.y + customNavigationBar.frame.size.height + 20, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.placeholder = NSLocalizedString(kPillReminderAlarmSearchPlaceholeder, nil);
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchTextField.delegate = self;
    [self.view addSubview:searchTextField];
    
    UIView *separatorLineViewTextField = [[UIView alloc] initWithFrame:CGRectMake(10, searchTextField.frame.origin.y + searchTextField.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    separatorLineViewTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:separatorLineViewTextField];
    
    startDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, searchTextField.frame.origin.y + searchTextField.frame.size.height + 40, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    startDateTextField.placeholder = NSLocalizedString(kPillReminderAlarmStartDatePlaceHolder, nil);
    startDateTextField.inputView = startDatePicker;
    startDateTextField.textAlignment = NSTextAlignmentCenter;
    startDateTextField.delegate = self;
    [self.view addSubview:startDateTextField];
    
    UIView *startDateSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(startDateTextField.frame.origin.x, startDateTextField.frame.origin.y + startDateTextField.frame.size.height - 1, startDateTextField.frame.size.width, 1)];
    startDateSeparatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:startDateSeparatorLine];
    
    endDateTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 10, searchTextField.frame.origin.y + searchTextField.frame.size.height + 40, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    endDateTextField.placeholder = NSLocalizedString(kPillReminderAlarmDurationPlaceholder, nil);
    endDateTextField.inputView = durationPicker;
    endDateTextField.textAlignment = NSTextAlignmentCenter;
    endDateTextField.delegate = self;
    [self.view addSubview:endDateTextField];
    
    UIView *endDateSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(endDateTextField.frame.origin.x, endDateTextField.frame.origin.y + endDateTextField.frame.size.height - 1, endDateTextField.frame.size.width, 1)];
    endDateSeparatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:endDateSeparatorLine];
    
    startTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, startDateTextField.frame.origin.y + startDateTextField.frame.size.height + 40, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    startTimeTextField.placeholder = NSLocalizedString(kPillReminderAlarmStartTimePlaceholder, nil);
    startTimeTextField.inputView = startTimePicker;
    startTimeTextField.textAlignment = NSTextAlignmentCenter;
    startTimeTextField.delegate = self;
    [self.view addSubview:startTimeTextField];
    
    UIView *startTimeSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(startTimeTextField.frame.origin.x, startTimeTextField.frame.origin.y + startTimeTextField.frame.size.height - 1, startTimeTextField.frame.size.width, 1)];
    startTimeSeparatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:startTimeSeparatorLine];
    
    intervalTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 10, endDateTextField.frame.origin.y + endDateTextField.frame.size.height + 40, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    intervalTimeTextField.placeholder = NSLocalizedString(kPillReminderAlarmIntervalPlaceholder, nil);
    intervalTimeTextField.inputView = intervalPicker;
    intervalTimeTextField.textAlignment = NSTextAlignmentCenter;
    intervalTimeTextField.delegate = self;
    [self.view addSubview:intervalTimeTextField];
    
    UIView *intervalTimeSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(intervalTimeTextField.frame.origin.x, intervalTimeTextField.frame.origin.y + intervalTimeTextField.frame.size.height - 1, intervalTimeTextField.frame.size.width, 1)];
    intervalTimeSeparatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:intervalTimeSeparatorLine];
    
    intervalDictionary = [[NSMutableDictionary alloc] init];
    [intervalDictionary setValue:[NSNumber numberWithInteger:1] forKey:@"1 Hour"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:2] forKey:@"2 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:4] forKey:@"4 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:6] forKey:@"6 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:8] forKey:@"8 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:10] forKey:@"10 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:12] forKey:@"12 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:24] forKey:@"24 Hours"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:48] forKey:@"2 days"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:168] forKey:@"1 week"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:336] forKey:@"2 weeks"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:360] forKey:@"15 days"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:504] forKey:@"3 weeks"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:672] forKey:@"4 weeks"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:720] forKey:@"1 month"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:1440] forKey:@"2 month"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:2160] forKey:@"3 months"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:2880] forKey:@"4 months"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:4320] forKey:@"6 months"];
    [intervalDictionary setValue:[NSNumber numberWithInteger:NSIntegerMax] forKey:@"Once"];
    
    durationDictionary = [[NSMutableDictionary alloc] init];
    [durationDictionary setValue:[NSNumber numberWithInteger:24] forKey:@"1 day"];
    [durationDictionary setValue:[NSNumber numberWithInteger:72] forKey:@"3 day"];
    [durationDictionary setValue:[NSNumber numberWithInteger:168] forKey:@"1 week"];
    [durationDictionary setValue:[NSNumber numberWithInteger:336] forKey:@"2 weeks"];
    [durationDictionary setValue:[NSNumber numberWithInteger:360] forKey:@"15 days"];
    [durationDictionary setValue:[NSNumber numberWithInteger:504] forKey:@"3 weeks"];
    [durationDictionary setValue:[NSNumber numberWithInteger:672] forKey:@"4 weeks"];
    [durationDictionary setValue:[NSNumber numberWithInteger:620] forKey:@"1 month"];
    [durationDictionary setValue:[NSNumber numberWithInteger:1440] forKey:@"2 month"];
    [durationDictionary setValue:[NSNumber numberWithInteger:NSIntegerMax] forKey:@"Rest of my life"];
    
    
    sortedKeys = [intervalDictionary keysSortedByValueUsingComparator:^(id first, id second) {
        return [first compare:second];
    }];
    
    sortedDurationArray = [durationDictionary keysSortedByValueUsingComparator:^(id first, id second) {
        return [first compare:second];
    }];
    
    startDatePicker.minimumDate = [NSDate date];
    endDatePicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:24*60*60];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [startTimePicker setLocale:locale];
    
    suggestionTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, separatorLineViewTextField.frame.origin.y + 1, [UIScreen mainScreen].bounds.size.width - 20, 176) style:UITableViewStylePlain];
    suggestionTableView.dataSource = self;
    suggestionTableView.delegate = self;
    suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    suggestionTableView.backgroundColor = [UIColor whiteColor];
    suggestionTableView.hidden = YES;
    suggestionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    suggestionTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    suggestionTableView.layer.borderWidth = 0.5f;
    [self.view addSubview:suggestionTableView];
    
    UIToolbar *toolBarStartDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBarStartDate setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(kPillReminderAlarmPickerDoneButton, nil)
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(selectStartDatePicker)];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBarStartDate.items = @[space1, barButtonDone1];
    barButtonDone1.tintColor=[UIColor blackColor];
    startDateTextField.inputAccessoryView = toolBarStartDate;
    
    UIToolbar *toolBarEndDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBarEndDate setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone2 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(kPillReminderAlarmPickerDoneButton, nil)
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(selectEndDatePicker)];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBarEndDate.items = @[space2, barButtonDone2];
    barButtonDone2.tintColor=[UIColor blackColor];
    endDateTextField.inputAccessoryView = toolBarEndDate;
    
    UIToolbar *toolBarStartTime = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBarStartTime setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone3 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(kPillReminderAlarmPickerDoneButton, nil)
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(selectStartTime)];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBarStartTime.items = @[space3, barButtonDone3];
    barButtonDone3.tintColor=[UIColor blackColor];
    startTimeTextField.inputAccessoryView = toolBarStartTime;
    
    UIToolbar *toolBarInterval = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44)];
    [toolBarInterval setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone4 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(kPillReminderAlarmPickerDoneButton, nil)
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(selectInterval)];
    UIBarButtonItem *space4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBarInterval.items = @[space4, barButtonDone4];
    barButtonDone4.tintColor=[UIColor blackColor];
    intervalTimeTextField.inputAccessoryView = toolBarInterval;
    
    if(self.isFromProductDetail)
    {
        searchTextField.text = self.productName;
        
        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
            {
                NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
                [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
                NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
                [df2 setDateFormat:@"MMMM'-'dd'-'y"];
                NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
                [df3 setDateFormat:@"hh':'mm' 'a"];
                
//                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", productId] , @"PRODUCT_ID", [df stringFromDate:startDate], @"START_DATE",  [df stringFromDate:endDate], @"END_DATE", [NSString stringWithFormat:@"%@",intervalTimeTextField.text], @"INTERVAL", nil];
                startDateTextField.text = [df2 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]];
                startTimeTextField.text = [df3 stringFromDate:[df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]]];
                NSLog(@"%@", notification.userInfo);
                intervalTimeTextField.text = [notification.userInfo objectForKey:@"INTERVAL"];
                endDateTextField.text = [notification.userInfo objectForKey:@"DURATION"];
                
                startDatePicker.date = [df1 dateFromString:[notification.userInfo objectForKey:@"START_DATE"]];
                break;
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

-(void)startTimer
{
    [self stopTimer];
    typeTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                 target:self
                                               selector:@selector(timerAction)
                                               userInfo:nil
                                                repeats:NO];
}

-(void)stopTimer
{
    [typeTimer invalidate];
    typeTimer = nil;
}

-(void)timerAction
{
    [self searchInDB];
    [self stopTimer];
}

-(void)searchInDB
{
    [suggestionArray removeAllObjects];
    [self getProductSuggestion:searchTextField.text];
    suggestionTableView.hidden = NO;
    [suggestionTableView reloadData];
}

-(void)selectStartDatePicker
{
    [startDateTextField resignFirstResponder];
}

-(void)selectEndDatePicker
{
    [endDateTextField resignFirstResponder];
}

-(void)selectStartTime
{
    [startTimeTextField resignFirstResponder];
}

-(void)selectInterval
{
    [intervalTimeTextField resignFirstResponder];
}

-(void)textFieldChanged:(NSNotification*)notification
{
    UITextField *textField = notification.object;
    if(textField == searchTextField)
    {
        suggestionTableView.hidden = YES;
        maxPage = 20;
        [self stopTimer];
        if([searchTextField.text length] > 2)
        {
            [self startTimer];
        }
    }
}

-(void)backButtonAction
{
    if ([self.navigationController.visibleViewController isKindOfClass:[UIAlertController class]])
    {
        UIAlertController *alertController = (UIAlertController*)self.navigationController.visibleViewController;
        [alertController removeFromParentViewController];
    }
//    if(self.isFromProductDetail)
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    if([self presentingViewController] || [[self presentingViewController] presentedViewController] == self || [[[self navigationController] presentingViewController] presentedViewController] == [self navigationController] || [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)submitButtonAction
{
    NSString *alertStr = @"";
    if([searchTextField.text isEqualToString:@""])
    {
        alertStr = NSLocalizedString(kPillReminderAlarmAlertMessageProduct, nil);
    }
    else if([startDateTextField.text isEqualToString:@""])
    {
        alertStr = NSLocalizedString(kPillReminderAlarmAlertMessageStartDate, nil);
    }
    else if([endDateTextField.text isEqualToString:@""])
    {
        alertStr = NSLocalizedString(kPillReminderAlarmAlertMessageDuration, nil);
    }
    else if([startTimeTextField.text isEqualToString:@""])
    {
        alertStr = NSLocalizedString(kPillReminderAlarmAlertMessageStartTime, nil);
    }
    else if([intervalTimeTextField.text isEqualToString:@""])
    {
        alertStr = NSLocalizedString(kPillReminderAlarmAlertMessageInterval, nil);
    }
    
    if(![alertStr isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(kPillReminderAlarmAlertDismiss, nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];
        
        [self presentViewController:alertController animated:YES completion:^{
            
            return;
        }];
        return;
    }
    
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[notification.userInfo objectForKey:@"PRODUCT_ID"] integerValue] == [productId integerValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM'-'dd'-'y'"];
    
    NSArray *hourMinitueArray = [startTimeTextField.text componentsSeparatedByString:@":"];
    NSDate *startDate = [[df dateFromString:startDateTextField.text] dateByAddingTimeInterval:([[hourMinitueArray objectAtIndex:0] intValue] * 60 * 60 + [[hourMinitueArray objectAtIndex:1] intValue] * 60)];
    NSLog(@"StartDate %@", startDate);
    NSDate *endDate = [startDate dateByAddingTimeInterval:[[durationDictionary objectForKey:endDateTextField.text] intValue] * 60 * 60];
//    NSDate *startDate = [NSDate date];//[df dateFromString:@"2016-07-23 04:07:30"];
//    NSDate *endDate = [[NSDate date] dateByAddingTimeInterval:60];//[df dateFromString:@"2016-07-23 04:08:30"];
//    NSLog(@"%@",endDate);
    NSLog(@"%@",startDate);
    
    selectedIntervalTime = [[intervalDictionary valueForKey:intervalTimeTextField.text] intValue];
    int totalNotification = [endDate timeIntervalSinceDate:startDate]/(selectedIntervalTime * 60 * 60);
    
    NSLog(@"%d",totalNotification);
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:startDate];
    localNotification.alertBody = [NSString stringWithFormat:@"%@", searchTextField.text];
    localNotification.alertTitle = [NSString stringWithFormat:@"Time to take medicine"];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    NSDictionary *userInfo = [[NSDictionary  alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@", productId] , @"PRODUCT_ID", [df1 stringFromDate:startDate], @"START_DATE",  [df stringFromDate:endDate], @"END_DATE", [NSString stringWithFormat:@"%@",intervalTimeTextField.text], @"INTERVAL", endDateTextField.text, @"DURATION", nil];
    localNotification.userInfo = userInfo;
    localNotification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    for(int i = 0; i < totalNotification - 1; i++)
    {
        startDate = [startDate dateByAddingTimeInterval:(selectedIntervalTime * 60 * 60)];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        [localNotification setFireDate:startDate];
        localNotification.alertBody = [NSString stringWithFormat:@"%@", searchTextField.text];
        localNotification.alertTitle = [NSString stringWithFormat:@"Time to take medicine"];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", productId] , @"PRODUCT_ID", [df1 stringFromDate:startDate], @"START_DATE",  [df stringFromDate:endDate], @"END_DATE", [NSString stringWithFormat:@"%@",intervalTimeTextField.text], @"INTERVAL", endDateTextField.text, @"DURATION", nil];
        localNotification.userInfo = userInfo;
        localNotification.repeatInterval = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(kPillReminderAlarmLoading, nil);;
    
    [self updateUserProductsWithProductId:self.productId];
}

-(IBAction)startDatePickerAction:(UIDatePicker*)sender
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"MMMM'-'dd'-'y"];
    startDateTextField.text = [df2 stringFromDate:[sender date]];
    
    endDatePicker.minimumDate = [startDatePicker.date dateByAddingTimeInterval:24*60*60];
    
    if([[df2 dateFromString:[df2 stringFromDate:[startDatePicker date]]] timeIntervalSinceDate:[df2 dateFromString:[df2 stringFromDate:[NSDate date]]]] == 0)
    {
        NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
        [df3 setDateFormat:@"hh':'mm' 'a"];
        NSLog(@"%@",[df3 dateFromString:[df3 stringFromDate:[NSDate date]]]);
        startTimePicker.minimumDate = [NSDate date];
        startTimeTextField.text = [df3 stringFromDate:[NSDate date]];
    }
    else
    {
        startTimePicker.minimumDate = nil;
    }
}

-(IBAction)endDatePickerAction:(UIDatePicker*)sender
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"MMMM'-'dd'-'y"];
    endDateTextField.text = [df2 stringFromDate:[sender date]];
}

-(IBAction)startTimePickerAction:(UIDatePicker*)sender
{
    NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
    [df3 setDateFormat:@"HH':'mm'"];
    startTimeTextField.text = [df3 stringFromDate:[sender date]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return suggestionArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdSuggestion";
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSDictionary *product = [suggestionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [product objectForKey:@"PRODUCT_PROPRIETARY_NAME"];
    cell.textLabel.minimumScaleFactor = 0.5f;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = [product objectForKey:@"NONPROPRIETARY_NAME"];
    cell.detailTextLabel.minimumScaleFactor = 0.5f;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    if (indexPath.row == [suggestionArray count] - 1 && [suggestionArray count] == maxPage)
    {
        maxPage += 20;
        [self getProductSuggestion:searchTextField.text];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *product = [suggestionArray objectAtIndex:indexPath.row];
    searchTextField.text = [product objectForKey:@"PRODUCT_PROPRIETARY_NAME"];
    [searchTextField resignFirstResponder];
    suggestionTableView.hidden = YES;
    productId = [product objectForKey:@"PRODUCT_ID"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == durationPicker)
    {
        return [durationDictionary allKeys].count;
    }
    return [intervalDictionary allKeys].count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == durationPicker)
    {
        return [sortedDurationArray objectAtIndex:row];
    }
    NSString *intervalTitle = [sortedKeys objectAtIndex:row];
    return intervalTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == durationPicker)
    {
        endDateTextField.text = [sortedDurationArray objectAtIndex:row];
    }
    else
    {
        NSString *intervalTitle = [sortedKeys objectAtIndex:row];
        intervalTimeTextField.text = intervalTitle;
        selectedIntervalTime = [[intervalDictionary valueForKey:intervalTitle] intValue];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == startDateTextField)
    {
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"MMMM'-'dd'-'y"];
        startDateTextField.text = [df2 stringFromDate:startDatePicker.date];
        
        if([[df2 dateFromString:[df2 stringFromDate:[startDatePicker date]]] timeIntervalSinceDate:[df2 dateFromString:[df2 stringFromDate:[NSDate date]]]] == 0)
        {
            NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
            [df3 setDateFormat:@"HH':'mm"];
            startTimePicker.minimumDate = [NSDate date];
            startTimeTextField.text = [df3 stringFromDate:[NSDate date]];
        }
    }
    else if(textField == endDateTextField)
    {
        if(endDateTextField.text && [endDateTextField.text isEqualToString:@""])
        {
            endDateTextField.text = [sortedDurationArray firstObject];
        }
    }
    else if(textField == startTimeTextField)
    {
        if(startTimeTextField.text && [startTimeTextField.text isEqualToString:@""])
        {
            NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
            [df3 setDateFormat:@"hh':'mm"];
            startTimeTextField.text = [df3 stringFromDate:startTimePicker.date];
        }
    }
    else if(textField == intervalTimeTextField)
    {
        if(intervalTimeTextField.text && [intervalTimeTextField.text isEqualToString:@""])
        {
            intervalTimeTextField.text = [sortedKeys firstObject];
            selectedIntervalTime = [[intervalDictionary valueForKey:intervalTimeTextField.text] intValue];
        }
    }
    
    if(textField == searchTextField)
    {
        if(self.isFromProductDetail)
        {
            return NO;
        }
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

-(void)getProductSuggestion:(NSString*)name
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:productGenericAutoComplete];
    [urlStr appendString:[NSString stringWithFormat:@"?term=%@",name]];
    [urlStr appendString:[NSString stringWithFormat:@"&maxPerPage=%@",[NSString stringWithFormat:@"%d",maxPage]]];
    [urlStr appendString:[NSString stringWithFormat:@"&currPage=%@",@"0"]];
    
    NSString *finalUrlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSLog(@"search product %@",finalUrlStr);
    NSURL *url = [NSURL URLWithString:finalUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [suggestionArray removeAllObjects];
                    [suggestionArray addObjectsFromArray:[dataJSON objectForKey:@"Data"]];
                    [suggestionTableView reloadData];
                });
            }
            else
            {
                NSLog(@"%@",error);
            }
        }
    }];
    [dataTask resume];
}

//-(void)updateUserProductsWithProductArray:(NSArray*)productArray DiseaseArray:(NSArray*)diseaseArray AllergenArray:(NSArray*)allergenArray AllergicProductArray:(NSArray*)allergicProductArray
//{
//    NSURL *URL = [NSURL URLWithString:updateUserProducts];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval = 30;
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"POST"];
//    
//    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
//    NSMutableArray *diseaseIdArray = [[NSMutableArray alloc] init];
//    NSMutableArray *allergenIdArray = [[NSMutableArray alloc] init];
//    NSMutableArray *allergicProductIdArray = [[NSMutableArray alloc] init];
//
//    for(NSDictionary *dict in productArray)
//    {
//        [productIdArray addObject:[dict objectForKey:@"PRODUCT_ID"]];
//    }
//    [productIdArray addObject:productId];
//    
//    for(NSDictionary *dict in diseaseArray)
//    {
//        [diseaseIdArray addObject:[dict objectForKey:@"DISEASE_ID"]];
//    }
//    
//    for(NSDictionary *dict in allergenArray)
//    {
//        [allergenIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
//    }
//    
//    for(NSDictionary *dict in allergicProductArray)
//    {
//        [allergicProductIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
//    }
//    
//    NSError *error;
//    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
//    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
//    [queryDictionary setObject:productIdArray forKey:@"PRODUCT_ID_LIST"];
//    [queryDictionary setObject:diseaseIdArray forKey:@"DISEASE_ID_LIST"];
//    [queryDictionary setObject:allergenIdArray forKey:@"ALLERGEN_ID_LIST"];
//    [queryDictionary setObject:allergicProductIdArray forKey:@"ALLERGIC_PRODUCT_ID_LIST"];
//    
//    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSDictionary *dataJSON;
//        if(data)
//        {
//            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//        }
//        
//        if(!error)
//        {
//            NSLog(@"updateUserProducts %@",dataJSON);
//            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    [self backButtonAction];
//                });
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            }
//        }
//        else
//        {
//            NSLog(@"%@",error);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//        }
//        
//    }];
//    [dataTask resume];
//}

-(void)updateUserProductsWithProductId:(NSString*)_productId
{
    NSURL *URL = [NSURL URLWithString:updateUserProducts2];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 30;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    [queryDictionary setObject:_productId forKey:@"PRODUCT_ID"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
        if(!error)
        {
            NSLog(@"updateUserProducts %@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlarmUpdated" object:nil userInfo:nil];
                    [self backButtonAction];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}


@end
