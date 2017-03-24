//
//  HomeCell.m
//  iOS Prototype
//
//  Created by World on 3/12/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

@synthesize cellName;
@synthesize cellImageView;
@synthesize isAccessoryViewPresent;
@synthesize customAccessoryViewLabelText;

- (id)initWithAccessoryView:(BOOL)_isAccessoryViewPresent;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTableViewCell"];
    if (self)
    {
        isAccessoryViewPresent = _isAccessoryViewPresent;
        
        cellName = [[UILabel alloc] init];
        cellName.backgroundColor = [UIColor clearColor];
        cellName.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:cellName];
        
        cellImageView = [[UIImageView alloc] init];
        cellImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellImageView];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = kNavigationBarColor;
        [self setSelectedBackgroundView:bgColorView];
        
        if(self.isAccessoryViewPresent)
        {
            customAccessoryView = [[UIView alloc] init];
            customAccessoryView.backgroundColor = [UIColor clearColor];
            
            customAccessoryViewBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AccessoryViewBG.png"]];
            customAccessoryView.frame = CGRectMake(0, 0, 23, 23);
            [customAccessoryView addSubview:customAccessoryViewBG];
            
            customAccessoryViewLabel = [[UILabel alloc] init];
            customAccessoryViewLabel.frame = CGRectMake(0, 0, 23, 23);
            customAccessoryViewLabel.textAlignment = NSTextAlignmentCenter;
            customAccessoryViewLabel.textColor = [UIColor whiteColor];
            [customAccessoryView addSubview:customAccessoryViewLabel];
            
            [self.contentView addSubview:customAccessoryView];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
//    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = self.contentView.bounds.size.height;
    
    cellImageView.frame = CGRectMake(x + 10, h / 2 - 36 / 2, 36, 36);
    cellName.frame = CGRectMake(cellImageView.frame.size.width + 20, y, 200, h);
    
    if(isAccessoryViewPresent)
    {
        customAccessoryView.frame = CGRectMake(270, h/2 - 23/2, 23, 23);
        customAccessoryViewLabel.text = customAccessoryViewLabelText;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
