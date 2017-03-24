//
//  ExplanationsTableViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 4/28/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplanationsTableViewCell : UITableViewCell
{
    UILabel *cellTitleLabel;
    UIImageView *ratingImageView;
    UIImageView *leftButtonImageView;
    
    UIView *titleViewContainer;
    UIView *expandedViewContainer;
    UIImageView *expandedImageView;
}
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UIImageView *ratingImageView;
@property (nonatomic, strong) UIImageView *leftButtonImageView;
@property (nonatomic, strong) UIImageView *expandedImageView;
@property (nonatomic) BOOL isExpanded;


@end
