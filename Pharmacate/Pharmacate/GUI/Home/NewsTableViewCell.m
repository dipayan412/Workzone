//
//  NewsTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/13/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

@synthesize newsImageView;
@synthesize newsTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        newsImageView = [[UIImageView alloc] init];
        newsImageView.backgroundColor = [UIColor clearColor];
        newsImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:newsImageView];
        
        newsTitleLabel = [[UILabel alloc] init];
        newsTitleLabel.backgroundColor = [UIColor clearColor];
        newsTitleLabel.numberOfLines = 3;
        [self.contentView addSubview:newsTitleLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    newsImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width/4,  self.contentView.frame.size.height);
    newsTitleLabel.frame = CGRectMake(self.contentView.frame.size.width/4 + 10, 0, self.contentView.frame.size.width - self.contentView.frame.size.width/4 - 10, self.contentView.frame.size.height);
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
