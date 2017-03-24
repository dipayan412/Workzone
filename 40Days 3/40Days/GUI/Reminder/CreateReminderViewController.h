//
//  CreateReminderViewController.h
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateReminderViewController : UIViewController
{
    IBOutlet UIButton *singleDayReminderButton;
    IBOutlet UIButton *repeatingReminderButton;
}
- (IBAction)singleDayReminder:(id)sender;
- (IBAction)repeatingReminder:(id)sender;

@end
