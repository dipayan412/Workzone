//
//  AlternativeCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/15/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlternateTableView.h"

@protocol AlternativeCellDelegate <NSObject>

-(void)alternativeProductSelectedWithProductId:(NSString *)_productId andName:(NSString *)_name;

@end

@interface AlternativeCell : UITableViewCell
{
    UILabel *cellTitleLabel;
    UIImageView *rightAccessoryImageView;
    UIView *customSeparatorView;
    UIView *topContainerView;
}

@property(nonatomic, strong) UILabel *cellTitleLabel;
@property(nonatomic, strong) UIImageView *rightAccessoryImageView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic) id <AlternativeCellDelegate> delegate;

@end
