//
//  ReviewTableViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/19/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *ratingLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *dataSourceLabel;

@end
