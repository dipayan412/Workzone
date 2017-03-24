//
//  AlternativeView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlternateViewDelegate <NSObject>

-(void)similarProductSelectionAction:(NSString*)_productId productName:(NSString*)_productName;

@end

@interface AlternativeView : UIView

@property(nonatomic) id <AlternateViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;

@end
