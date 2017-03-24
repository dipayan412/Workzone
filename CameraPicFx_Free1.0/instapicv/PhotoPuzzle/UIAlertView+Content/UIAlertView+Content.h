//
//  UIAlertView+Content.h
//
//  Created by Alexey Naumov on 12/24/12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//


@protocol UIAlertViewContentDelegate <UIAlertViewDelegate>

@optional
- (BOOL) alertView:(UIAlertView *)alertView allowClickButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface UIAlertView (Content)

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                             message: (NSString *) message
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle;

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                         contentView: (UIView *) contentView
                       keepSideRatio: (BOOL) keepSideRatio
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle;

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                        contentView1: (UIView *) contentView1
                      keepSideRatio1: (BOOL) keepSideRatio1
                        contentView2: (UIView *) contentView2
                      keepSideRatio2: (BOOL) keepSideRatio2
                       contentsRatio: (CGFloat) contentsRatio
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle;

- (UIView *) contentView1;
- (UIView *) contentView2;

+ (UIAlertView *) alertViewWithIcon: (UIImage *) icon
                          iconRatio: (CGFloat) iconRatio
                              title: (NSString *) title
                            message: (NSString *) message
                           delegate: (id) delegate
                  cancelButtonTitle: (NSString *) cancelButtonTitle
                 confirmButtonTitle: (NSString *) confirmButtonTitle;

@end
