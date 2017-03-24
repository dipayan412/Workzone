//
//  CheckInCell.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInCell : UITableViewCell
{
    UILabel *dateLabel;
    UILabel *cityCountryLabel;
}
@property (nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic, readonly) UILabel *cityCountryLabel;
@end
