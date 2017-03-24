//
//  RA_SettingsCell.h
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsCellDelegate <NSObject>

-(void)checkBoxIsSelected:(BOOL)isSelected action:(kSettingsOptions)action;

@end

@interface RA_SettingsCell : UITableViewCell
{
    UILabel *actionNameLabel;
    UIImageView *checkBoxImageView;
    UIButton *checkBoxButton;
}

@property (nonatomic, retain) UILabel *actionNameLabel;
@property (nonatomic, assign) BOOL isCheckBoxSelected;
@property (nonatomic, retain) id <SettingsCellDelegate> delegate;
@property (nonatomic, assign) kSettingsOptions action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier checkBoxSelected:(BOOL)isSelected action:(kSettingsOptions)_action;

-(void)deselectCheckBox;

@end
