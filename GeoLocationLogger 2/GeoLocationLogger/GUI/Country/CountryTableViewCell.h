//
//  CountryTableViewCell.h
//  MyPosition
//
//  Created by World on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryTableViewCellDelegate <NSObject>

-(void)detailButtonActionWithIndexPath:(NSIndexPath*)indexpath;

@end

@interface CountryTableViewCell : UITableViewCell
{
    UIImageView *countryFlagImageView;
    UIImageView *totalVisitIconImageView;
    UIImageView *lastVisitIconImageView;
    UIButton *detailButtonIcon;
    UILabel *countryNameLabel;
    UIButton *detailButton;
    UILabel *totalVisitLabel;
    UILabel *lastVisitDateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath*)indexPath;

@property(nonatomic, retain) UIImageView *countryFlagImageView;
@property(nonatomic, retain) UILabel *countryNameLabel;
@property(nonatomic, retain) UIButton *detailButton;
@property(nonatomic, retain) UILabel *totalVisitLabel;
@property(nonatomic, retain) UILabel *lastVisitDateLabel;
@property(nonatomic, retain) NSIndexPath *indexpath;
@property(nonatomic, retain) id <CountryTableViewCellDelegate> delegate;


@end
