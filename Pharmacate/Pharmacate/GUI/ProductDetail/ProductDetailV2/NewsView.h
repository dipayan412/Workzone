//
//  NewsView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsViewDelegate <NSObject>

-(void)newsCellActionUrlString:(NSString*)urlStr;
-(void)recallCellActionForDictionary:(NSDictionary*)dictionary;

@end

@interface NewsView : UIView

@property(nonatomic) id<NewsViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId;

@end
