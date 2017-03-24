//
//  ProductDetailV2PanelView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDetailV2PanelViewDelegate <NSObject>

-(void)overViewButtonAction;
-(void)explanataionButtonAction;
-(void)newsButtonAction;
-(void)alternativeButtonAction;
-(void)reviewButtonAction;

@end

@interface ProductDetailV2PanelView : UIView

@property(nonatomic) id<ProductDetailV2PanelViewDelegate> delegate;
-(void)explanationButtonAction:(UIButton*)button;

@end
