//
//  SearchCell.h
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCellDelegate <NSObject>

-(void)sendRequestButtonPressedAt:(int)row;

@end

@interface SearchCell : UITableViewCell
{
    UIButton *sendRequestButton;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id <SearchCellDelegate> delegate;
@property (nonatomic, assign) BOOL isRequestSent;
@property (nonatomic, strong) UIButton *sendRequestButton;

@end
