//
//  NewsTableViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/13/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
{
    UIImageView *newsImageView;
    UILabel *newsTitleLabel;
}

@property(nonatomic, strong) UIImageView *newsImageView;
@property(nonatomic, strong) UILabel *newsTitleLabel;

@end
