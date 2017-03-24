//
//  ExplanationsTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 4/28/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ExplanationsTableViewCell.h"

@implementation ExplanationsTableViewCell
{
    int x;
    int width;
}

@synthesize cellTitleLabel;
@synthesize ratingImageView;
@synthesize leftButtonImageView;
@synthesize isExpanded;
@synthesize expandedImageView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        x = 20;
        width = 374;
        isExpanded = NO;
        
        titleViewContainer = [[UIView alloc] init];
        titleViewContainer.backgroundColor = [UIColor clearColor];
        
        cellTitleLabel = [[UILabel alloc] init];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        [titleViewContainer addSubview:cellTitleLabel];
        
        ratingImageView = [[UIImageView alloc] init];
        ratingImageView.backgroundColor = [UIColor clearColor];
        ratingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [titleViewContainer addSubview:ratingImageView];
        
        leftButtonImageView = [[UIImageView alloc] init];
        leftButtonImageView.backgroundColor = [UIColor clearColor];
        leftButtonImageView.contentMode = UIViewContentModeScaleAspectFit;
        leftButtonImageView.image = [UIImage imageNamed:@"forwardButton.png"];
        [titleViewContainer addSubview:leftButtonImageView];
        
        expandedViewContainer = [[UIView alloc] init];
        expandedViewContainer.backgroundColor = [UIColor clearColor];
        
        expandedImageView = [[UIImageView alloc] init];
        expandedImageView.backgroundColor = [UIColor clearColor];
        expandedImageView.contentMode = UIViewContentModeScaleAspectFit;
        expandedImageView.image = [UIImage imageNamed:@"expandedCellExplanations.png"];
        [expandedViewContainer addSubview:expandedImageView];
        
        [self.contentView addSubview:expandedViewContainer];
        [self.contentView addSubview:titleViewContainer];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    titleViewContainer.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 80);
    cellTitleLabel.frame = CGRectMake(10, 0, 250, titleViewContainer.frame.size.height);
    ratingImageView.frame = CGRectMake(cellTitleLabel.frame.size.width + 10, 15, 50, 50);
    leftButtonImageView.frame = CGRectMake(titleViewContainer.frame.size.width - 40, 30, 30, 30);
    
    UIView *vwTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, titleViewContainer.frame.size.width, 1)];
    [vwTop setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [titleViewContainer addSubview:vwTop];
    
    UIView *vwBot=[[UIView alloc] initWithFrame:CGRectMake(0, titleViewContainer.frame.size.height, titleViewContainer.frame.size.width, 1)];
    [vwBot setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [titleViewContainer addSubview:vwBot];
    
    UIView *vwLeft=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, titleViewContainer.frame.size.height)];
    [vwLeft setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [titleViewContainer addSubview:vwLeft];
    
    UIView *vwRight=[[UIView alloc] initWithFrame:CGRectMake(titleViewContainer.frame.size.width, 0, 1, titleViewContainer.frame.size.height)];
    [vwRight setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [titleViewContainer addSubview:vwRight];
    if(isExpanded)
    {
        expandedImageView.image = [UIImage imageNamed:@"expandedCellExplanations.png"];
        expandedViewContainer.frame = CGRectMake(0, titleViewContainer.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height - titleViewContainer.frame.size.height);
        expandedImageView.frame = CGRectMake(0, 0, expandedViewContainer.frame.size.width, expandedViewContainer.frame.size.height);
        titleViewContainer.backgroundColor = [UIColor colorWithRed:253.0f/255 green:190.0f/255 blue:59.0f/255 alpha:1.0];
        leftButtonImageView.image = [UIImage imageNamed:@"downButton.png"];
    }
    else
    {
        expandedViewContainer.frame = CGRectMake(0, 0, 0, 0);
        expandedImageView.frame = CGRectMake(0, 0, 0, 0);
        titleViewContainer.backgroundColor = [UIColor clearColor];
        leftButtonImageView.image = [UIImage imageNamed:@"forwardButton.png"];
    }
}

-(void)setIsExpanded:(BOOL)_isExpanded
{
    isExpanded = _isExpanded;
//    if(isExpanded)
//    {
//        leftButtonImageView.image = [UIImage imageNamed:@"downButton.png"];
//        titleViewContainer.backgroundColor = [UIColor colorWithRed:253.0f/255 green:190.0f/255 blue:59.0f/255 alpha:1.0];
//    }
//    else
//    {
//        leftButtonImageView.image = [UIImage imageNamed:@"forwardButton.png"];
//        titleViewContainer.backgroundColor = [UIColor clearColor];
//    }
//    [self layoutSubviews];
}

-(void)setFrame:(CGRect)frame
{
//    int inset = 21;
    frame.origin.x = x;
    frame.size.width = width;
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
