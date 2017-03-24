//
//  SettingController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 18/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookController.h"
#import "FacebookShareDelegate.h"

@interface SettingController : UIViewController <UITableViewDelegate, UITableViewDataSource, FacebookShareDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *settingTable;
    NSMutableDictionary *tittleDict;
    
    UISwitch *facebookSwitch;
    UISwitch *dropboxSwitch;
    
    UIView *loadingView;
    
    UIAlertView *loadingAlert;
}

@end
