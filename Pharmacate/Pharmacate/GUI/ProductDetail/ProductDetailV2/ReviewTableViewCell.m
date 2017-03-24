//
//  ReviewTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/19/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ReviewTableViewCell.h"

@interface ReviewTableViewCell()
{
    UILabel *ratingFullLabel;
}

@end

@implementation ReviewTableViewCell

@synthesize ratingLabel;
@synthesize contentLabel;
@synthesize dateLabel;
@synthesize nameLabel;
@synthesize userImageView;
@synthesize dataSourceLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        userImageView = [[UIImageView alloc] init];
        userImageView.backgroundColor = [UIColor clearColor];
        userImageView.contentMode = UIViewContentModeScaleAspectFit;
        userImageView.layer.cornerRadius =  25;
        userImageView.clipsToBounds = YES;
        userImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:userImageView];
        
        ratingLabel = [[UILabel alloc] init];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.font = [UIFont systemFontOfSize:11.0f];
        [self.contentView addSubview:ratingLabel];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:11.0f];
        [self.contentView addSubview:dateLabel];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:nameLabel];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 1000;
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:contentLabel];
        
        dataSourceLabel = [[UILabel alloc] init];
        dataSourceLabel.backgroundColor = [UIColor clearColor];
        dataSourceLabel.font = [UIFont systemFontOfSize:9.0f];
        dataSourceLabel.textColor = [UIColor lightGrayColor];
        dataSourceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dataSourceLabel];
        
//        ratingFullLabel = [[UILabel alloc] init];
//        ratingFullLabel.backgroundColor = [UIColor clearColor];
//        ratingFullLabel.text = @"/ 10";
//        ratingFullLabel.font = [UIFont systemFontOfSize:11.0f];
//        [self.contentView addSubview:ratingFullLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    userImageView.frame = CGRectMake(0, self.contentView.frame.size.height/2 - 25, 50, 50);
    nameLabel.frame = CGRectMake(userImageView.frame.size.width, 0, 150, 20);
    dateLabel.frame = CGRectMake(self.contentView.frame.size.width - 120, self.contentView.frame.size.height - 20, 120, 20);
//    ratingFullLabel.frame = CGRectMake(self.contentView.frame.size.width - 30, 0, 30, 20);
    ratingLabel.frame = CGRectMake(self.contentView.frame.size.width - 85, 0, 85, 20);
    contentLabel.frame = CGRectMake(userImageView.frame.size.width, ratingLabel.frame.size.height, self.contentView.frame.size.width - userImageView.frame.size.width, self.contentView.frame.size.height - ratingLabel.frame.size.height - dateLabel.frame.size.height);
    dataSourceLabel.frame = CGRectMake(contentLabel.frame.origin.x, dateLabel.frame.origin.y, self.contentView.frame.size.width - dateLabel.frame.size.width - userImageView.frame.size.width, dateLabel.frame.size.height);
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
