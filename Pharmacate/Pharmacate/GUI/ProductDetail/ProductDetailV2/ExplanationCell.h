//
//  ExplanationCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/27/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplanationCell : UITableViewCell
{
    UILabel *cellTitleLabel;
    UILabel *gradeLabel;
    UIImageView *rightAccessoryImageView;
    UILabel *contentLabel;
    UIView *customSeparatorView;
    UIView *topContainerView;
}
@property(nonatomic, strong) UILabel *cellTitleLabel;
@property(nonatomic, strong) UILabel *gradeLabel;
@property(nonatomic, strong) UIImageView *rightAccessoryImageView;
@property(nonatomic, strong) UILabel *contentLabel;

@end
