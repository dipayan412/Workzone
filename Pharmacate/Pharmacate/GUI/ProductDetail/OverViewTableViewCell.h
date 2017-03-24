//
//  OverViewTableViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 4/27/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverViewTableViewCell : UITableViewCell
{
    UIImageView *tempImageView;
    UIImageView *userImageView;
    UILabel *numberOfReviewsLabel;
    UITextField *userCommentTextField;
}

@property (nonatomic, strong) UIImageView *tempImageView;
@property (nonatomic) int cellPosition;
@property (nonatomic) int cellType;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *numberOfReviewsLabel;
@property (nonatomic, strong) UITextField *userCommentTextField;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellPosition:(int)position withCellType:(int)type indexPath:(NSIndexPath*)indexPath;

@end
