//
//  RA_GalleryCellCell.m
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_GalleryCellCell.h"

@implementation RA_GalleryCellCell

@synthesize leftImageView;
@synthesize rightImageView;
@synthesize centerImageView;
@synthesize leftImageButton;
@synthesize centerImageButton;
@synthesize rightImageButton;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        leftImageView = [[UIImageView alloc] init];
        leftImageView.backgroundColor = [UIColor clearColor];
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:leftImageView];
        
        centerImageView = [[UIImageView alloc] init];
        centerImageView.backgroundColor = [UIColor clearColor];
        centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:centerImageView];
        
        rightImageView = [[UIImageView alloc] init];
        rightImageView.backgroundColor = [UIColor clearColor];
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:rightImageView];
        
        leftImageButton = [[UIButton alloc] init];
        leftImageButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:leftImageButton];
        [leftImageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        centerImageButton = [[UIButton alloc] init];
        centerImageButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:centerImageButton];
        [centerImageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        rightImageButton = [[UIButton alloc] init];
        rightImageButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rightImageButton];
        [rightImageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    leftImageView.frame = CGRectMake(x + 5, y + 5, w/3 - 10, h - 10);
    centerImageView.frame = CGRectMake(leftImageView.bounds.origin.x + leftImageView.bounds.size.width + 10, y + 5, w/3 - 5, h - 10);
    rightImageView.frame = CGRectMake(centerImageView.frame.origin.x + centerImageView.frame.size.width + 5, y + 5, w/3 - 5, h - 10);
    
    leftImageButton.frame = CGRectMake(x + 5, y + 5, w/3 - 10, h - 10);
    centerImageButton.frame = CGRectMake(leftImageButton.bounds.origin.x + leftImageButton.bounds.size.width + 10, y + 5, w/3 - 5, h - 10);
    rightImageButton.frame = CGRectMake(centerImageButton.frame.origin.x + centerImageButton.frame.size.width + 5, y + 5, w/3 - 5, h - 10);
}

-(void)reorderTags:(int)_tag1 tag2:(int)_tag2 tag3:(int)_tag3
{
    if(_tag1 < 0)
    {
        leftImageButton.hidden =
        leftImageView.hidden = YES;
    }
    else
    {
        leftImageButton.hidden =
        leftImageView.hidden = NO;
    }
    if (_tag2 < 0)
    {
        centerImageButton.hidden =
        centerImageView.hidden = YES;
    }
    else
    {
        centerImageButton.hidden =
        centerImageView.hidden = NO;
    }
    if (_tag3 < 0)
    {
        rightImageButton.hidden =
        rightImageView.hidden = YES;
    }
    else
    {
        rightImageButton.hidden =
        rightImageView.hidden = NO;
    }
    
    leftImageButton.tag = _tag1;
    centerImageButton.tag = _tag2;
    rightImageButton.tag = _tag3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)imageTapped:(UIButton*)sender
{
    // send the tag number of the button to the viewcontroller which has been tapped
    if(delegate && sender.tag >= 0)
    {
        [delegate indexOfTappedImage:(int)sender.tag];
    }
}

@end
