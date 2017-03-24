//
//  RA_CategoryCell.m
//  RestaurantApp
//
//  Created by World on 1/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "RA_CategoryCell.h"

@implementation RA_CategoryCell

@synthesize categoryNameLabel;
@synthesize categoryImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //initializing all the elements of a single row
        
        //show the name of the category
        categoryNameLabel = [[UILabel alloc] init];
        categoryNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:categoryNameLabel];
        categoryNameLabel.textColor = kCellTitleColor;
        categoryNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
        
        if([UIScreen mainScreen].bounds.size.height > 568)//font size for ipad
        {
            categoryNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        }
        else//font size for iphone
        {
            categoryNameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        }
        
        // shows the image of the category object
        categoryImageView = [[UIImageView alloc] init];
        categoryImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:categoryImageView];
        
        //background styling of the image of the category object
        categoryImageBGView = [[UIView alloc] init];
        categoryImageBGView.backgroundColor = [UIColor clearColor];
        categoryImageBGView.layer.borderWidth = 1.0f;
        categoryImageBGView.layer.borderColor = kBorderColor;
        categoryImageBGView.layer.cornerRadius = 2.0f;
        [self.contentView addSubview:categoryImageBGView];
        
        //creating custom cell separator (the grey line to seperate cells)
        separatorView = [[UIImageView alloc] init];
        separatorView.backgroundColor = [UIColor colorWithPatternImage:kCellSeparator];
        [self.contentView addSubview:separatorView];
        
        //creating custom cell indicator (the arrow sign)
        cellIndicatorView = [[UIImageView alloc] init];
        cellIndicatorView.backgroundColor = [UIColor colorWithPatternImage:kCellIndicator];
        [self.contentView addSubview:cellIndicatorView];
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
    
    //aligning the view of the row
    categoryImageBGView.frame = CGRectMake(5, 4, h - 10, h - 10);
    categoryImageView.frame = CGRectMake(7, 6, h - 14, h - 14);
    categoryNameLabel.frame = CGRectMake(categoryImageBGView.frame.size.width + 20, y, 300, h);
    cellIndicatorView.frame = CGRectMake(w - 18, h/2 - 5, 6, 10);
    separatorView.frame = CGRectMake(x, h - 1, w, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
