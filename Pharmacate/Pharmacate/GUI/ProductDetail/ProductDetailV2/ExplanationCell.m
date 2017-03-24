//
//  ExplanationCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/27/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ExplanationCell.h"

#define cellHeight 60
#define gradeInset 10

@implementation ExplanationCell

@synthesize cellTitleLabel;
@synthesize gradeLabel;
@synthesize rightAccessoryImageView;
@synthesize contentLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topContainerView = [[UIView alloc] init];
        topContainerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:topContainerView];
        
        cellTitleLabel = [[UILabel alloc] init];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:cellTitleLabel];
        
        gradeLabel = [[UILabel alloc] init];
        gradeLabel.backgroundColor = [UIColor clearColor];
        gradeLabel.layer.cornerRadius = (cellHeight - gradeInset)/2;
//        gradeLabel.layer.borderColor = [UIColor redColor].CGColor;
//        gradeLabel.layer.borderWidth = 2.0f;
//        gradeLabel.text = @"A";
        gradeLabel.textAlignment = NSTextAlignmentCenter;
        gradeLabel.font = [UIFont systemFontOfSize:25.0f];
//        gradeLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:gradeLabel];
        
        rightAccessoryImageView = [[UIImageView alloc] init];
        rightAccessoryImageView.backgroundColor = [UIColor clearColor];
        rightAccessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:rightAccessoryImageView];
        
        customSeparatorView = [[UIView alloc] init];
        customSeparatorView.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:customSeparatorView];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 1000;
        contentLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:contentLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    topContainerView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, cellHeight);
    cellTitleLabel.frame = CGRectMake(5, 0, 3*self.contentView.frame.size.width/4 + 5, cellHeight);
    rightAccessoryImageView.frame = CGRectMake(self.contentView.frame.size.width - cellHeight/2, cellHeight/4, cellHeight/2, cellHeight/2);
    gradeLabel.frame = CGRectMake(rightAccessoryImageView.frame.origin.x - cellHeight - 10, cellHeight/2 - (cellHeight - gradeInset)/2, cellHeight - gradeInset, cellHeight - gradeInset);
    customSeparatorView.frame = CGRectMake(0, cellTitleLabel.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
    contentLabel.frame = CGRectMake(15, cellHeight, self.contentView.frame.size.width - 15, self.contentView.frame.size.height - cellHeight);
    if(self.contentView.frame.size.height > cellHeight)
    {
        topContainerView.backgroundColor = themeColor;
    }
    else
    {
        topContainerView.backgroundColor = [UIColor clearColor];
    }
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
