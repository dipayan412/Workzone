//
//  EmailCell.h
//  Grabber
//
//  Created by World on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmailCellDelegate <NSObject>

-(void)emailSelected:(BOOL)_isSelected atIndexPath:(NSIndexPath*)_indexPath;

@end

@interface EmailCell : UITableViewCell
{
    UILabel *nameLabel;
    UIButton *checkBoxButton;
    UIImageView *proPicImgView;
    
    NSIndexPath *indexpath;
    BOOL isCheckBoxSelected;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *proPicImgView;
@property (nonatomic, retain) id <EmailCellDelegate> delegate;

-(void)checkBoxButtonAction;
-(void)selectAllCheckBox;
-(void)deselectAllCheckBox;

@end
