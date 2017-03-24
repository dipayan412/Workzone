//
//  SettingsV2Cell.m
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SettingsV2Cell.h"

@implementation SettingsV2Cell

@synthesize cellIconImageView;
@synthesize cellNameLabel;

- (id)initWithCustomCellIndicator:(BOOL)_value
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsPage"];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:131.0f/255.0f green:73.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
        
        cellIconImageView = [[UIImageView alloc] init];
        cellIconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellIconImageView];
        
        cellNameLabel = [[UILabel alloc] init];
        cellNameLabel.backgroundColor = [UIColor clearColor];
        cellNameLabel.font = [UIFont systemFontOfSize:11.0f];
        cellNameLabel.textColor = [UIColor lightGrayColor];//[UIColor colorWithRed:223.0f/255.0f green:212.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
        [self.contentView addSubview:cellNameLabel];
        
        if(_value)
        {
            customCellIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CustomCellIndicator.png"]];
            customCellIndicatorView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:customCellIndicatorView];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    cellIconImageView.frame = CGRectMake(10, self.contentView.frame.size.height/2 - 11, 21, 21);
    cellNameLabel.frame = CGRectMake(70, 0, 250, self.contentView.frame.size.height);
    customCellIndicatorView.frame = CGRectMake(294, self.contentView.frame.size.height/2 - 5, 6, 9);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
