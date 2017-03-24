//
//  UserDrawerViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 9/19/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserDrawerViewCell.h"

@implementation UserDrawerViewCell

@synthesize cellTitle;
@synthesize cellImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellImageView = [[UIImageView alloc] init];
        cellImageView.backgroundColor = [UIColor clearColor];
        cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:cellImageView];
        
        cellTitle = [[UILabel alloc] init];
        cellTitle.backgroundColor = [UIColor clearColor];
        cellTitle.font = [UIFont systemFontOfSize:15.0f];
        cellTitle.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:cellTitle];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    cellImageView.frame = CGRectMake(20, self.contentView.frame.size.height/2 - 10, 20, 20);
    cellTitle.frame = CGRectMake(cellImageView.frame.origin.x + cellImageView.frame.size.width + 5, 0, self.contentView.frame.size.width - (cellImageView.frame.origin.x + cellImageView.frame.size.width + 5), self.contentView.frame.size.height);
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
