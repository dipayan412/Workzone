//
//  OverViewTableViewCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 4/27/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "OverViewTableViewCell.h"

@implementation OverViewTableViewCell

@synthesize tempImageView;
@synthesize cellPosition;
@synthesize cellType;
@synthesize userImageView;
@synthesize userCommentTextField;
@synthesize numberOfReviewsLabel;
@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellPosition:(int)position withCellType:(int)type indexPath:(NSIndexPath*)_indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.indexPath = _indexPath;
        self.cellType = type;
        if(type == 1)
        {
            userImageView = [[UIImageView alloc] init];
            userImageView.backgroundColor = [UIColor clearColor];
            userImageView.contentMode = UIViewContentModeScaleAspectFit;
            [userImageView setImage:[UIImage imageNamed:@"userImageIcon.tiff"]];
            [self.contentView addSubview:userImageView];
            
            numberOfReviewsLabel = [[UILabel alloc] init];
            numberOfReviewsLabel.backgroundColor = [UIColor clearColor];
            numberOfReviewsLabel.textAlignment = NSTextAlignmentLeft;
            numberOfReviewsLabel.text = @"3 user reviews";
            [self.contentView addSubview:numberOfReviewsLabel];
            
            userCommentTextField = [[UITextField alloc] init];
            userCommentTextField.placeholder = @"Share your thoughts...";
            userCommentTextField.textAlignment = NSTextAlignmentLeft;
            userCommentTextField.backgroundColor = [UIColor clearColor];
            userCommentTextField.borderStyle = UITextBorderStyleNone;
            [self.contentView addSubview:userCommentTextField];
        }
        else
        {
            tempImageView = [[UIImageView alloc] init];
            tempImageView.backgroundColor = [UIColor clearColor];
            tempImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:tempImageView];
        }
        self.cellPosition = position;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    tempImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    if(self.indexPath.row == 0)
    {
        UIView *vwTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
        [vwTop setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
        [self.contentView addSubview:vwTop];
    }
    if(self.indexPath.row == cellPosition)
    {
        UIView *vwBot=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, 1)];
        [vwBot setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
        [self.contentView addSubview:vwBot];
    }
    UIView *vwLeft=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.contentView.frame.size.height)];
    [vwLeft setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [self.contentView addSubview:vwLeft];
    
    UIView *vwRight=[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width, 0, 1, self.contentView.frame.size.height)];
    [vwRight setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
    [self.contentView addSubview:vwRight];
    
    if(self.cellType == 1)
    {
        CGRect frame = numberOfReviewsLabel.frame;
        frame.origin.x = 10;
        frame.origin.y = 5;
        frame.size.width = 200;
        frame.size.height = 20;
        numberOfReviewsLabel.frame = frame;
        
        frame = userImageView.frame;
        frame.origin.x = 0;
        frame.origin.y = numberOfReviewsLabel.frame.size.height + numberOfReviewsLabel.frame.origin.y + 10;
        frame.size.width = 70;
        frame.size.height = 70;
        userImageView.frame = frame;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(userImageView.frame.size.width + 16, 90, 270, 1)];
        [separatorView setBackgroundColor:[UIColor colorWithRed:204.0f/255 green:204.0f/255 blue:204.0f/255 alpha:204.0f/255]];
        [self.contentView addSubview:separatorView];
        
        frame = separatorView.frame;
        frame.origin.y -= 35;
        frame.size.height = 30;
        userCommentTextField.frame = frame;
    }
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
