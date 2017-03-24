//
//  RA_ItemCell.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_ItemCell : UITableViewCell
{
    UIView *recipeImageBGView;
    UIImageView *authorImageView;
    UIImageView *cellIndicatorView;
    UIImageView *recipeImageView;
    UIImageView *separatorView;
    UILabel *recipeNameLabel;
    UILabel *priceLabel;
}

@property (nonatomic, retain) UIImageView *authorImageView;
@property (nonatomic, retain) UIImageView *recipeImageView;
@property (nonatomic, retain) UILabel *recipeNameLabel;
@property (nonatomic, retain) UILabel *priceLabel;

@end
