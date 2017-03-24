//
//  SearchTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 4/26/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

@synthesize tempImageView;
@synthesize productName;
@synthesize genericName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.contentView.backgroundColor = [UIColor clearColor];
        
//        tempImageView = [[UIImageView alloc] init];
//        tempImageView.backgroundColor = [UIColor clearColor];
//        tempImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:tempImageView];
        
        productName = [[UILabel alloc] init];
        productName.backgroundColor = [UIColor clearColor];
        productName.font = [UIFont boldSystemFontOfSize:17.0];
        productName.textColor = [UIColor redColor];
        [self.contentView addSubview:productName];
        
        genericName = [[UILabel alloc] init];
        genericName.backgroundColor = [UIColor clearColor];
        genericName.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:genericName];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    tempImageView.frame = CGRectMake(0, 0, 20, 20);
    productName.frame = CGRectMake(40, 5, self.contentView.frame.size.width - 40, self.contentView.frame.size.height / 2);
    genericName.frame = CGRectMake(40, self.contentView.frame.size.height / 2, self.contentView.frame.size.width - 40, self.contentView.frame.size.height / 2 - 5);
    
//    UIView *vwTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
//    [vwTop setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
//    [self.contentView addSubview:vwTop];
    UIView *vwBot=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, 1)];
    [vwBot setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [self.contentView addSubview:vwBot];
    UIView *vwLeft=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.contentView.frame.size.height)];
    [vwLeft setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [self.contentView addSubview:vwLeft];
    UIView *vwRight=[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width, 0, 1, self.contentView.frame.size.height)];
    [vwRight setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [self.contentView addSubview:vwRight];
}

//-(void)setFrame:(CGRect)frame
//{
//    int inset = 21;
//    frame.origin.x += inset;
//    frame.size.width -= 2 * inset;
//    [super setFrame:frame];
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
