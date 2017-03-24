//
//  ExplanationView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExplanationViewDelegate <NSObject>

-(void)intersectSelectionAction:(NSString*)_productId productName:(NSString*)_productName;

@end

@interface ExplanationView : UIView

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;

@property(nonatomic) id <ExplanationViewDelegate> delegate;

@end
