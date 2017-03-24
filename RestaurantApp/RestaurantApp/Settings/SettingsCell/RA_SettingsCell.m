//
//  RA_SettingsCell.m
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_SettingsCell.h"

@implementation RA_SettingsCell

@synthesize actionNameLabel;
@synthesize isCheckBoxSelected;
@synthesize delegate;
@synthesize action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier checkBoxSelected:(BOOL)isSelected action:(kSettingsOptions)_action
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isCheckBoxSelected = isSelected;
        self.action = _action;
        
        //shows the name of the action(connect to fb or twitter)
        actionNameLabel = [[UILabel alloc] init];
        actionNameLabel.backgroundColor = [UIColor clearColor];
        actionNameLabel.textColor = kSettingsPageCommonColor;
        actionNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
        
        if([UIScreen mainScreen].bounds.size.height > 568)
        {
            actionNameLabel.font = [UIFont systemFontOfSize:17.0f];
        }
        else
        {
            actionNameLabel.font = [UIFont systemFontOfSize:13.0f];
        }
        
        [self.contentView addSubview:actionNameLabel];
        
        //initializes the checkbox of the action
        checkBoxImageView = [[UIImageView alloc] init];
        if(isSelected)
        {
            [checkBoxImageView setImage:kCheckBoxSelected];
        }
        else
        {
            [checkBoxImageView setImage:kCheckBoxDeselcted];
        }
        [self.contentView addSubview:checkBoxImageView];
        
        //the button behind the action which handles the action of the checkbox
        checkBoxButton = [[UIButton alloc] init];
        checkBoxButton.backgroundColor = [UIColor clearColor];
        [checkBoxButton addTarget:self action:@selector(checkBoxButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:checkBoxButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
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
    
    actionNameLabel.frame = CGRectMake(x + 10, y, w/2 + 200, h);
    checkBoxImageView.frame = CGRectMake(260, y + 19, 24, 24);
    checkBoxButton.frame = CGRectMake(260, y + 19, 24, 24);
    if([UIScreen mainScreen].bounds.size.height > 568)
    {
        actionNameLabel.frame = CGRectMake(x + 50, y, w/2 + 200, h);
        checkBoxImageView.frame = CGRectMake(self.contentView.frame.size.width - 60, y + 19, 24, 24);
        checkBoxButton.frame = CGRectMake(self.contentView.frame.size.width - 60, y + 19, 24, 24);
    }
}

/**
 * Method name: checkBoxButtonTapped
 * Description: update the image of the check box button after every tap, notifies the viewcontroller and the viewcontroller takes action against it
 * Parameters: none
 */

-(void)checkBoxButtonTapped
{
    self.isCheckBoxSelected = !self.isCheckBoxSelected;
    if(self.isCheckBoxSelected)
    {
        [checkBoxImageView setImage:kCheckBoxSelected];
    }
    else
    {
        [checkBoxImageView setImage:kCheckBoxDeselcted];
    }
    
    if(delegate)
    {
        [delegate checkBoxIsSelected:self.isCheckBoxSelected action:self.action];
    }
}

-(void)deselectCheckBox
{
    self.isCheckBoxSelected = NO;
    [checkBoxImageView setImage:kCheckBoxDeselcted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
