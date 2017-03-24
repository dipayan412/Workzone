//
//  RA_LanguageSwitchCell.h
//  RestaurantApp
//
//  Created by World on 1/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageCellDelegate <NSObject>

-(void)languageChanged:(BOOL)_isOn;

@end

@interface RA_LanguageSwitchCell : UITableViewCell
{
    UILabel *languageSwicthLabel;
    UISwitch *changeLanguageSwitch;
}

@property (nonatomic, retain) id<LanguageCellDelegate> delegate;

-(void)changeLang;

@end
