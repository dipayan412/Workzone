//
//  RA_OrderLaterCheckBoxCell.m
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_OrderLaterCheckBoxCell.h"

@implementation RA_OrderLaterCheckBoxCell

@synthesize delegate;
@synthesize isCheckBoxSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCheckboxSelected:(BOOL)isSeleted
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isCheckBoxSelected = isSeleted;
        
        //the checkbox which determines whther the order will be taken later or not
        orderLaterLabel = [[UILabel alloc] init];
        orderLaterLabel.text = @"Check if you want to order later";
        orderLaterLabel.textColor = [UIColor grayColor];
        orderLaterLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:orderLaterLabel];
        
        checkBoxImageView = [[UIImageView alloc] init];
        
        if(isSeleted)
        {
            [checkBoxImageView setImage:kCheckBoxSelected];
        }
        else
        {
            [checkBoxImageView setImage:kCheckBoxDeselcted];
        }
        [self.contentView addSubview:checkBoxImageView];
        
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
//    CGFloat w = self.contentView.bounds.size.width;
    
    checkBoxImageView.frame = CGRectMake(x + 20, h/2 - 12, 24, 24);
    checkBoxButton.frame = CGRectMake(x + 20, h/2 - 12, 24, 24);
    orderLaterLabel.frame = CGRectMake(x + 60, y, 300, h);
}

/**
 * Method name: checkBoxButtonTapped
 * Description: update the image of the check box button after every tap, notifies the viewcontroller and the viewcontroller takes action action against it
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
        [delegate checkBoxButtonSelected:self.isCheckBoxSelected];
    }
}

/**
 * Method name: changeLabel
 * Description: update static strings to the language chosen
 * Parameters: none
 */

-(void)changeLabel
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    orderLaterLabel.text = AMLocalizedString(@"kOrderLaterCheckBox", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
