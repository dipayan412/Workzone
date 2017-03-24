//
//  ShopCreateLocationCell.h
//  iOS Prototype
//
//  Created by World on 3/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCreateLocationCellDelegate <NSObject>

-(void)locateButtonTapped;

@end

@interface ShopCreateLocationCell : UITableViewCell
{
    UILabel *locationCellName;
    BMMapView *locationMapView;
    UIButton *locateButton;
}
@property (nonatomic, retain) UILabel *locationCellName;
@property (nonatomic, retain) BMMapView *locationMapView;
@property (nonatomic, retain) id <ShopCreateLocationCellDelegate> delegate;

- (id)init;
@end
