//
//  ProductSelectionView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSelectionViewDelegate <NSObject>

-(void)changeInSelectedProductArray:(NSArray*)array;

@end

@interface ProductSelectionView : UIView

@property(nonatomic) id<ProductSelectionViewDelegate> delegate;
@property(nonatomic) NSMutableArray *selectedProductArray;

@end
