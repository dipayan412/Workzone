//
//  SearchCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "SearchCell.h"

#define imageViewHeight 60

@implementation SearchCell

@synthesize productImageView;
@synthesize productNameLabel;
@synthesize sourceLabel;
@synthesize typeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        productImageView = [[UIImageView alloc] init];
        productImageView.contentMode = UIViewContentModeScaleAspectFit;
        productImageView.backgroundColor = [UIColor clearColor];
//        productImageView.layer.cornerRadius = imageViewHeight/2;
        productImageView.clipsToBounds = YES;
        [self.contentView addSubview:productImageView];
        
        productNameLabel = [[UILabel alloc] init];
        productNameLabel.backgroundColor = [UIColor clearColor];
        productNameLabel.numberOfLines = 3;
        [self.contentView addSubview:productNameLabel];
        
        sourceLabel = [[UILabel alloc] init];
        sourceLabel.backgroundColor = [UIColor clearColor];
        sourceLabel.textColor = [UIColor lightGrayColor];
        sourceLabel.font = [UIFont systemFontOfSize:9.0f];
        [self.contentView addSubview:sourceLabel];
        
        typeLabel = [[UILabel alloc] init];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textColor = [UIColor lightGrayColor];
        typeLabel.font = [UIFont systemFontOfSize:9.0f];
        [self.contentView addSubview:typeLabel];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    productImageView.frame = CGRectMake(5, self.contentView.frame.size.height/2 - imageViewHeight/2, imageViewHeight,  imageViewHeight);
    sourceLabel.frame = CGRectMake(self.contentView.frame.size.width - 100, self.contentView.frame.size.height - 20, 100, 10);
    productNameLabel.frame = CGRectMake(self.contentView.frame.size.width/4 + 10, 0, self.contentView.frame.size.width - self.contentView.frame.size.width/4 - sourceLabel.frame.size.width - 10, self.contentView.frame.size.height);
    typeLabel.frame = CGRectMake(sourceLabel.frame.origin.x, 10, 100, 10);
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
