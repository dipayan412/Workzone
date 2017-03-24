//
//  SettingsV2Cell.h
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsV2Cell : UITableViewCell
{
    UIImageView *cellIconImageView;
    UILabel *cellNameLabel;
    UIImageView *customCellIndicatorView;
}
@property (nonatomic, retain) UIImageView *cellIconImageView;
@property (nonatomic, retain) UILabel *cellNameLabel;

- (id)initWithCustomCellIndicator:(BOOL)_value;

@end
