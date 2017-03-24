//
//  RA_LanguageSwitchCell.m
//  RestaurantApp
//
//  Created by World on 1/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RA_LanguageSwitchCell.h"

@implementation RA_LanguageSwitchCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        
        //shows the name of the language which can be turned on for the app
        languageSwicthLabel = [[UILabel alloc] init];
        languageSwicthLabel.text = AMLocalizedString(@"kUseItalian", nil);
        languageSwicthLabel.backgroundColor = [UIColor clearColor];
        languageSwicthLabel.textColor = kSettingsPageCommonColor;
        languageSwicthLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
        if([UIScreen mainScreen].bounds.size.height > 568)
        {
            languageSwicthLabel.font = [UIFont systemFontOfSize:17.0f];
        }
        else
        {
            languageSwicthLabel.font = [UIFont systemFontOfSize:13.0f];
        }
        [self.contentView addSubview:languageSwicthLabel];
        
        changeLanguageSwitch = [[UISwitch alloc] init];
        changeLanguageSwitch.backgroundColor = [UIColor clearColor];
        [changeLanguageSwitch addTarget:self action:@selector(languageChangedAction) forControlEvents:UIControlEventValueChanged];
        changeLanguageSwitch.on = [RA_UserDefaultsManager isLanguageItalian];
        [self.contentView addSubview:changeLanguageSwitch];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat h = self.contentView.bounds.size.height;
    CGFloat w = self.contentView.bounds.size.width;
    
    languageSwicthLabel.frame = CGRectMake(x + 10, y, 100, h);
    changeLanguageSwitch.frame = CGRectMake(w - 60, h/2 - 15, 51, 31);
    if([UIScreen mainScreen].bounds.size.height > 568)
    {
        languageSwicthLabel.frame = CGRectMake(x + 50, y, 100, h);
        changeLanguageSwitch.frame = CGRectMake(w - 80, h/2 - 15, 51, 31);
    }
}

/**
 * Method name: languageChangedAction
 * Description: notifies the view controller that app language has been changed
 * Parameters: italian is on or off
 */

-(void)languageChangedAction
{
    if(delegate)
    {
        [delegate languageChanged:changeLanguageSwitch.on];
    }
}

/**
 * Method name: changeLang
 * Description: update static strings to the language chosen
 * Parameters: none
 */

-(void)changeLang
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    languageSwicthLabel.text = AMLocalizedString(@"kUseItalian", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
