//
//  UserDrawerViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 9/19/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDrawerViewCell : UITableViewCell
{
    UIImageView *cellImageView;
    UILabel *cellTitle;
}

@property(nonatomic, strong) UIImageView *cellImageView;
@property(nonatomic, strong) UILabel *cellTitle;

@end
