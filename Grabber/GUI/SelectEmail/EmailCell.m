//
//  EmailCell.m
//  Grabber
//
//  Created by World on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "EmailCell.h"

@implementation EmailCell

@synthesize nameLabel;
@synthesize delegate;
@synthesize proPicImgView;
@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:nameLabel];
        
        proPicImgView = [[UIImageView alloc] init];
        proPicImgView.backgroundColor = [UIColor clearColor];
        proPicImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:proPicImgView];
        
        checkBoxButton = [[UIButton alloc] init];
        [checkBoxButton setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
        [checkBoxButton addTarget:self action:@selector(checkBoxButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [self.contentView addSubview:checkBoxButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    proPicImgView.frame = CGRectMake(10, 6, 32, 32);
    nameLabel.frame = CGRectMake(proPicImgView.frame.size.width + 30, 0, 200, self.contentView.frame.size.height);
    checkBoxButton.frame = CGRectMake(260, 0, 44, self.contentView.frame.size.height);
}

-(void)checkBoxButtonAction
{
    isCheckBoxSelected = !isCheckBoxSelected;
    if(isCheckBoxSelected)
    {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
    }
    
    if(delegate)
    {
        [delegate emailSelected:isCheckBoxSelected atIndexPath:self.indexPath];
    }
}

-(void)selectAllCheckBox
{
    [checkBoxButton setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
    
    if(delegate)
    {
        [delegate emailSelected:YES atIndexPath:self.indexPath];
    }
}

-(void)deselectAllCheckBox
{
    [checkBoxButton setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
    
    if(delegate)
    {
        [delegate emailSelected:NO atIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
