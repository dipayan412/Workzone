//
//  HomeTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 4/13/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

@synthesize tempImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        tempImageView = [[UIImageView alloc] init];
        tempImageView.backgroundColor = [UIColor clearColor];
        tempImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:tempImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    tempImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

-(void)setFrame:(CGRect)frame
{
    int inset = 21;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
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
