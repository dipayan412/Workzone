//
//  CommonSwitchCell.h
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@protocol CommonSwitchCellDelegate <NSObject>

-(void)switchValueChangedTo:(BOOL)value forCellType:(kCellTypes)_type;

@end

@interface CommonSwitchCell : UITableViewCell
{
    UISwitch *fieldSwitch;
    BOOL switchValue;
    int type;
}

@property (nonatomic, retain) UISwitch *fieldSwitch;
@property (nonatomic, retain) id <CommonSwitchCellDelegate> delegate;
@property (nonatomic, retain) NSString *subtitleString;

- (id)initWithValue:(BOOL)_value withTitle:(NSString*)_titleString withSubtitle:(NSString*)_subtitle withCellTypes:(kCellTypes)_type;

@end
