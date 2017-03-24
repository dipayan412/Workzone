//
//  CountryTableViewCell.m
//  MyPosition
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "CountryTableViewCell.h"

@implementation CountryTableViewCell

@synthesize delegate;
@synthesize indexpath;
@synthesize countryFlagImageView;
@synthesize countryNameLabel;
@synthesize detailButton;
@synthesize totalVisitLabel;
@synthesize lastVisitDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath*)_indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.indexpath = _indexPath;
        
        countryFlagImageView = [[UIImageView alloc] init];
        
        countryNameLabel = [[UILabel alloc] init];
        countryNameLabel.font = [UIFont systemFontOfSize:13];
        
        detailButton = [[UIButton alloc] init];
        detailButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        totalVisitLabel = [[UILabel alloc] init];
        totalVisitLabel.font = [UIFont systemFontOfSize:13];
        
        lastVisitDateLabel = [[UILabel alloc] init];
        lastVisitDateLabel.font = [UIFont systemFontOfSize:13];
        lastVisitDateLabel.textAlignment = UITextAlignmentRight;
        
        [totalVisitLabel setTextColor:[UIColor colorWithRed:109.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0f]];
        [lastVisitDateLabel setTextColor:[UIColor colorWithRed:109.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0f]];
        
        lastVisitIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lastVisitIcon.png"]];
        totalVisitIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"totalVisitIcon.png"]];
        
        detailButtonIcon = [[UIButton alloc] init];
        [detailButtonIcon setImage:[UIImage imageNamed:@"detailButtonIcon.png"] forState:UIControlStateNormal];
        
        [detailButton addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [detailButtonIcon addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        countryFlagImageView.backgroundColor = [UIColor clearColor];
        countryNameLabel.backgroundColor = [UIColor clearColor];
        [countryNameLabel setTextColor:[UIColor colorWithRed:252.0f / 255.0f green:131.0f / 255.0f blue:36.0f / 255.0f alpha:1]];
        [detailButton setTitle:@"Detail" forState:UIControlStateNormal];
        [detailButton setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        detailButton.backgroundColor = [UIColor clearColor];
        
        totalVisitLabel.backgroundColor = [UIColor clearColor];
        lastVisitDateLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:countryFlagImageView];
        [self.contentView addSubview:countryNameLabel];
        [self.contentView addSubview:detailButton];
        [self.contentView addSubview:totalVisitLabel];
        [self.contentView addSubview:lastVisitDateLabel];
        [self.contentView addSubview:totalVisitIconImageView];
        [self.contentView addSubview:lastVisitIconImageView];
        [self.contentView addSubview:detailButtonIcon];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = self.contentView.bounds.size.height;
    
    countryFlagImageView.frame = CGRectMake(x + 10, y + 5, w - 20, h / 2);
    
    countryNameLabel.frame = CGRectMake(x+10, countryFlagImageView.frame.size.height + 15, 140, 20);
    detailButton.frame = CGRectMake(250, countryFlagImageView.frame.size.height + 15, 50, 20);
    detailButtonIcon.frame = CGRectMake(292, countryFlagImageView.frame.size.height + 15, 20, 20);
    
    totalVisitLabel.frame = CGRectMake(x + 35, countryNameLabel.frame.origin.y + countryNameLabel.frame.size.height, 140, 20);
    lastVisitDateLabel.frame = CGRectMake(170, countryNameLabel.frame.origin.y + countryNameLabel.frame.size.height, 135, 20);
    lastVisitIconImageView.frame = CGRectMake(155, countryNameLabel.frame.origin.y + countryNameLabel.frame.size.height, 20, 20);
    totalVisitIconImageView.frame = CGRectMake(10, countryNameLabel.frame.origin.y + countryNameLabel.frame.size.height, 20, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)detailButtonAction
{
    if(delegate)
    {
        [delegate detailButtonActionWithIndexPath:self.indexpath];
    }
}

@end
