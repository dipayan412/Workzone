//
//  SearchCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
{
    UIImageView *productImageView;
    UILabel *productNameLabel;
    UILabel *sourceLabel;
    UILabel *typeLabel;
}
@property(nonatomic, strong) UIImageView *productImageView;
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, strong) UILabel *sourceLabel;
@property(nonatomic, strong) UILabel *typeLabel;

@end
