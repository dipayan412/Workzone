//
//  UIView+FormScroll.h
//  MyVB
//
//  Created by User on 12/17/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end
