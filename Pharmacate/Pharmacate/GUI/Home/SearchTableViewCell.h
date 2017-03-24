//
//  SearchTableViewCell.h
//  Pharmacate
//
//  Created by Dipayan Banik on 4/26/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
{
    UIImageView *tempImageView;
    UILabel *productName;
    UILabel *genericName;
}
@property (nonatomic, strong) UIImageView *tempImageView;
@property (nonatomic, strong) UILabel *productName;
@property (nonatomic, strong) UILabel *genericName;

@end
