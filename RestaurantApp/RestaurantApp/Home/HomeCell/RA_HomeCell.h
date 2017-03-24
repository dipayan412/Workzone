//
//  RA_HomeCell.h
//  RestaurantApp
//
//  Created by World on 12/20/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RA_HomeCell : UITableViewCell
{
    UIImageView *pageImageView;
    UIImageView *cellIdicatorView;
    UIImageView *separatorView;
    UILabel *pageNameLabel;
    UIView *pageImageBackgroundView;
}

@property (nonatomic, retain) UIImageView *pageImageView;
@property (nonatomic, retain) UILabel *pageNameLabel;

@end
