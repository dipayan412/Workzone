//
//  HistoryTableViewCell.h
//  MyPosition
//
//  Created by World on 11/17/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
{
    UILabel *cityCountryLabel;
    UILabel *dateLabel;
    UIImageView *attachmentImageView;
}
@property (nonatomic, retain) UILabel *cityCountryLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *attachmentImageView;

@end
