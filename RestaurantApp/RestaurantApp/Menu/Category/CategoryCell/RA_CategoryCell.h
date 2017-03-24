//
//  RA_CategoryCell.h
//  RestaurantApp
//
//  Created by World on 1/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_CategoryCell : UITableViewCell
{
    UIView *categoryImageBGView;
    UIImageView *cellIndicatorView;
    UIImageView *categoryImageView;
    UIImageView *separatorView;
    UILabel *categoryNameLabel;
}

@property (nonatomic, retain) UIImageView *categoryImageView;
@property (nonatomic, retain) UILabel *categoryNameLabel;

@end
