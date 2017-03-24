//
//  RA_HomeCell.m
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_HomeCell.h"

@implementation RA_HomeCell

@synthesize pageImageView;
@synthesize pageNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // feature cell name label attributes configured
        
        // shows the name of the page which will be showed after tapping on the cell
        pageNameLabel = [[UILabel alloc] init];
        pageNameLabel.backgroundColor = [UIColor clearColor];
        pageNameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:pageNameLabel];
        pageNameLabel.textColor = kCellTitleColor;
        pageNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
        
        if([UIScreen mainScreen].bounds.size.height > 568)
        {
            pageNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        }
        else
        {
            pageNameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        }
        
        // feature image background view configured
        // background styling of the page image
        pageImageBackgroundView = [[UIView alloc] init];
        pageImageBackgroundView.backgroundColor = [UIColor whiteColor];
        pageImageBackgroundView.layer.borderWidth = 1.0f;
        pageImageBackgroundView.layer.borderColor = kBorderColor;
        pageImageBackgroundView.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:pageImageBackgroundView];
        
        // image view of the cell
        // show the image of the page
        pageImageView = [[UIImageView alloc] init];
        pageImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:pageImageView];
        
        // custom cell indicator created(the arrow sign)
        cellIdicatorView = [[UIImageView alloc] init];
        cellIdicatorView.backgroundColor = [UIColor colorWithPatternImage:kCellIndicator];
        [self.contentView addSubview:cellIdicatorView];
        
        // custom separator view created(the grey line to seperate cells)
        separatorView = [[UIImageView alloc] init];
        separatorView.backgroundColor = [UIColor colorWithPatternImage:kCellSeparator];
        [self.contentView addSubview:separatorView];
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
    
    
    // elements of the cell organized according to the docs provided
    pageImageBackgroundView.frame = CGRectMake(x + 5, y + 4, h - 10, h - 10);
    pageImageView.frame = CGRectMake(x + 7, y + 6, h - 14, h - 14);
    pageNameLabel.frame = CGRectMake(pageImageBackgroundView.frame.size.width + 20, y, 300, h);
    cellIdicatorView.frame = CGRectMake(w - 18, h/2 - 5, 6, 10);
    separatorView.frame = CGRectMake(x, h - 1, w, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
