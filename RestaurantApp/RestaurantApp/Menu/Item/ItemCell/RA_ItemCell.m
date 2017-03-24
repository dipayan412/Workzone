//
//  RA_ItemCell.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ItemCell.h"

@implementation RA_ItemCell

@synthesize recipeImageView;
@synthesize authorImageView;
@synthesize recipeNameLabel;
@synthesize priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //initializing all the elements of a single cell
        
        //shows the name of the item
        recipeNameLabel = [[UILabel alloc] init];
        recipeNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:recipeNameLabel];
        recipeNameLabel.textColor = kCellTitleColor;
        recipeNameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0f];
        
        if([UIScreen mainScreen].bounds.size.height > 568)
        {
            recipeNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        }
        else
        {
            recipeNameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        }
        
        //shows the price of the item object
        priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:priceLabel];
        priceLabel.textColor = kTextItemCellPriceLabelTextColor;
        priceLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
        
        if([UIScreen mainScreen].bounds.size.height > 568)//ipad
        {
            priceLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        }
        else//iphone
        {
            priceLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        }
        
        //shows the image of the recipe image view
        recipeImageView = [[UIImageView alloc] init];
        recipeImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:recipeImageView];
        
        recipeImageBGView = [[UIView alloc] init];
        recipeImageBGView.backgroundColor = [UIColor clearColor];
        recipeImageBGView.layer.borderWidth = 1.0f;
        recipeImageBGView.layer.borderColor = kBorderColor;
        recipeImageBGView.layer.cornerRadius = 2.0f;
        [self.contentView addSubview:recipeImageBGView];
        
        authorImageView = [[UIImageView alloc] init];
        authorImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:authorImageView];
        
        //creating custom separatorview (the grey line to separate cells)
        separatorView = [[UIImageView alloc] init];
        separatorView.backgroundColor = [UIColor colorWithPatternImage:kCellSeparator];
        [self.contentView addSubview:separatorView];
        
        //creating custom indicatorview (the arrow sign)
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
    
    //alligning all the elemnts of a single cell according to the docs provided
    recipeImageBGView.frame = CGRectMake(5,y + 4, h - 10, h - 10);
    recipeImageView.frame = CGRectMake(7, 6, h - 14, h - 14);
    recipeNameLabel.frame = CGRectMake(recipeImageBGView.frame.size.width + 20, h/5, 100, 20);
    priceLabel.frame = CGRectMake(recipeImageBGView.frame.size.width + 20, h/2, 100, 20);
    authorImageView.frame = CGRectMake(244, 20, 24, 24);
    cellIndicatorView.frame = CGRectMake(w - 18, h/2 - 5, 6, 10);
    separatorView.frame = CGRectMake(x, h - 1, w, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
