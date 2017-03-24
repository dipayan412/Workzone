//
//  UIAlertView+Content.m
//
//  Created by Alexey Naumov on 12/24/12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//

#import "UIAlertView+Content.h"

static CGFloat const kSideSpace = 12.0f;
static CGFloat const kHeaderOffset = - 2.0f;
static CGFloat const kHeaderLineHeigth = 22.0f;
static CGFloat const kMessageLineHeigth = 20.0f;
static CGFloat const kAlertViewWidth = 286.0f;
static NSInteger const kTagConventView = NSIntegerMin;


@protocol TouchDetecterViewDelegate <NSObject>

- (BOOL) swallowTouchInZoneAtIndex: (NSInteger) zoneIndex;

@end

@interface TouchDetecterView : UIView
@property (nonatomic, unsafe_unretained) NSInteger zonesCount;
@property (nonatomic, unsafe_unretained) id<TouchDetecterViewDelegate> delegate;

+ (TouchDetecterView *) view;

@end

@implementation TouchDetecterView
@synthesize zonesCount;
@synthesize delegate;

+ (TouchDetecterView *) view
{
    return [[[TouchDetecterView alloc] initWithFrame:CGRectNull] autorelease];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.zonesCount = 1;
    }
    return self;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super pointInside:point withEvent:event])
    {
        static NSTimeInterval lastTimeStamp = 0;
        static BOOL prevResult = NO;
//        NSTimeInterval timeStamp = [event timestamp]; // work incorrect
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        if (fabsf(lastTimeStamp - timeStamp) > 0.1)
        {
            lastTimeStamp = timeStamp;
            NSInteger zoneIndex = [self zoneIndexForPoint:point];
            if (zoneIndex >= 0 && zoneIndex < zonesCount)
            {
                if ([delegate swallowTouchInZoneAtIndex:zoneIndex])
                {
                    prevResult = YES;
                    return YES;
                } else {
                    prevResult = NO;
                }
            }
        } else {
            return prevResult;
        }
    }
    return NO;
}

- (NSInteger) zoneIndexForPoint: (CGPoint) point
{
    CGSize viewSize = self.bounds.size;
    assert(zonesCount);
    CGFloat zoneWidth = viewSize.width / zonesCount;
    NSInteger zoneIndex = floorf(point.x / zoneWidth);
    return zoneIndex;
}

@end

@interface UIAlertView (Private) <TouchDetecterViewDelegate>

@end

@implementation UIAlertView (Private)

+ (NSInteger) linesForTitle: (NSString *) title
{
    NSInteger lines = 0;
    if (title.length > 0)
    {
        UILabel * header = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAlertViewWidth - 2.0 * kSideSpace, 1000.0f)];
        header.numberOfLines = 0;
        header.textAlignment = NSTextAlignmentCenter;
        header.lineBreakMode = NSLineBreakByWordWrapping;
        header.font = [UIFont boldSystemFontOfSize:18];
        header.text = title;
        [header sizeToFit];
        lines = header.bounds.size.height / 22.0;
    }
    return lines;
}

+ (NSInteger) linesForMessageWithLinesForTitle: (NSInteger) linesForTitle
                                  withKeyboard: (BOOL) useKeyboard
{
    BOOL isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    NSInteger linesForMessage = 0;
    if (isPhone) {
        if (useKeyboard) {
            linesForMessage = 4;
        } else {
            linesForMessage = 7;
        }
    } else {
        if (useKeyboard) {
            linesForMessage = 6;
        } else {
            linesForMessage = 13;
        }
    }
    linesForMessage -= linesForTitle;
    if (isPhone) {
        if (linesForTitle > 4) {
            linesForMessage = 1;
        }
        if (linesForTitle > 6) {
            linesForMessage = 0;
        }
    } else {
        if (linesForTitle > 1) {
            linesForMessage -= 1;
        }
    }
    return MAX(linesForMessage, 0);
}

+ (NSInteger) linesForContentWithHeight: (CGFloat) height
                          linesForTitle: (NSInteger) linesForTitle
                           withKeyboard: (BOOL) useKeyboard
{
    CGFloat desiredSpaceCount = /*ceil*/floor(height / kMessageLineHeigth);
    NSInteger maxLinesCount = [self linesForMessageWithLinesForTitle:linesForTitle
                                                        withKeyboard:useKeyboard];
    return MIN(desiredSpaceCount,maxLinesCount);
}

- (void) applyCountOfLinesForMessage: (NSInteger) countOfLines
{
    NSString * spaces = @"";
    for (int i = 0; i < countOfLines; ++i)
    {
        spaces = [spaces stringByAppendingString:@"\n"];
    }
    self.message = spaces;
}

- (CGRect) contentRectWithDesiredHeight: (CGFloat) desiredHeight
                             alertTitle: (NSString *) title
                           withKeyboard: (BOOL) useKeyboard
{
    NSInteger linesForTitle = [UIAlertView linesForTitle:title];
    NSInteger linesForContent = [UIAlertView linesForContentWithHeight:desiredHeight
                                                                     linesForTitle:linesForTitle
                                                                      withKeyboard:useKeyboard];
    [self applyCountOfLinesForMessage:linesForContent];
    CGFloat messageHeight = (linesForContent + 1.0f) * kMessageLineHeigth;
    CGFloat headerHeight = kHeaderOffset;
    if (linesForTitle > 0)
    {
        headerHeight += kSideSpace + linesForTitle * kHeaderLineHeigth;
        messageHeight -= kSideSpace;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && useKeyboard) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight) {
            CGFloat contraction = kSideSpace * 0.5f - kHeaderOffset;
            if (!linesForTitle) {
                contraction = 1.5f * kSideSpace;
                headerHeight += kHeaderOffset;
            } else {
                headerHeight -= kSideSpace;
            }
            messageHeight = MAX(0.0f, messageHeight - contraction);
        }
    }
    return CGRectMake(kSideSpace,
                      kSideSpace + headerHeight,
                      kAlertViewWidth - 2.0f * kSideSpace,
                      messageHeight);
}

+ (CGSize) sizeOfView: (UIView *) view
             thatFits: (CGSize) contentSize
        keepSideRatio: (BOOL) keepSideRatio
{
    CGSize desiredSize = view.bounds.size;
    if (keepSideRatio) {
        CGFloat factorX = 1.0;
        if (desiredSize.width > 0.0f)  {
            factorX = contentSize.width / desiredSize.width;
        }
        CGFloat factorY = 1.0f;
        if (desiredSize.height > 0.0f) {
            factorY = contentSize.height / desiredSize.height;
        }
        CGFloat factor = MIN(factorX, factorY);
        if (factor < 1.0f) {
            desiredSize.width *= factor;
            desiredSize.height *= factor;
        }
    } else {
        desiredSize = contentSize;
    }
    view.bounds = CGRectMake(0.0f, 0.0f, desiredSize.width, desiredSize.height);
    CGSize sizeThatFits = desiredSize;
    if ([view isKindOfClass:[UILabel class]])
    {
        sizeThatFits = [view sizeThatFits:desiredSize];
    }
    return sizeThatFits;
};

#pragma mark - TouchDetecterViewDelegate

- (BOOL) swallowTouchInZoneAtIndex: (NSInteger) zoneIndex
{
    if ([self.delegate respondsToSelector:@selector(alertView:allowClickButtonAtIndex:)])
    {
        return ![self.delegate alertView:self allowClickButtonAtIndex:zoneIndex];
    }
    return NO;
}

@end

@implementation UIAlertView (Content)

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                             message: (NSString *) message
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle
{
    return [[[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:delegate
                             cancelButtonTitle:cancelButtonTitle
                             otherButtonTitles:confirmButtonTitle, nil]
            autorelease];
}

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                         contentView: (UIView *) contentView
                       keepSideRatio: (BOOL) keepSideRatio
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle
{
    return [UIAlertView alertViewWithTitle:title
                              contentView1:contentView
                            keepSideRatio1:keepSideRatio
                              contentView2:nil
                            keepSideRatio2:NO
                             contentsRatio:1.0f
                                  delegate:delegate
                         cancelButtonTitle:cancelButtonTitle
                        confirmButtonTitle:confirmButtonTitle];
}

+ (UIAlertView *) alertViewWithTitle: (NSString *) title
                        contentView1: (UIView *) contentView1
                      keepSideRatio1: (BOOL) keepSideRatio1
                        contentView2: (UIView *) contentView2
                      keepSideRatio2: (BOOL) keepSideRatio2
                       contentsRatio: (CGFloat) contentsRatio
                            delegate: (id) delegate
                   cancelButtonTitle: (NSString *) cancelButtonTitle
                  confirmButtonTitle: (NSString *) confirmButtonTitle
{
    NSParameterAssert(contentsRatio >= 0.0f && contentsRatio <= 1.0f);
    if (contentView1)
    {
        NSParameterAssert(contentView1 != contentView2);
    }
    UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:title
                                                          message:nil
                                                         delegate:delegate
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:confirmButtonTitle, nil]
                               autorelease];
    NSInteger spacesCount = 3;
    if (!contentView1 || !contentView2)
    {
        spacesCount = 2;
    }
    CGFloat contentWidth1 = (kAlertViewWidth - spacesCount * kSideSpace) * contentsRatio;
    CGFloat contentWidth2 = (kAlertViewWidth - spacesCount * kSideSpace) * ( 1.0f - contentsRatio);
    CGFloat desiredHeight1 = contentView1.bounds.size.height;
    if (keepSideRatio1 && (contentView1.bounds.size.width > contentWidth1))
    {
        desiredHeight1 *= contentWidth1 / contentView1.bounds.size.width;
    }
    CGFloat desiredHeight2 = contentView2.bounds.size.height;
    if (keepSideRatio2 && (contentView2.bounds.size.width > contentWidth2))
    {
        desiredHeight2 *= contentWidth2 / contentView2.bounds.size.width;
    }
    BOOL useKeyboard = [contentView1 canBecomeFirstResponder] || [contentView2 canBecomeFirstResponder];
    CGRect contentRect = [alertView contentRectWithDesiredHeight:MAX(desiredHeight1, desiredHeight2)
                                                      alertTitle:title
                                                    withKeyboard:useKeyboard];
    CGSize viewSize1 = [self sizeOfView:contentView1
                               thatFits:CGSizeMake(contentWidth1, contentRect.size.height)
                          keepSideRatio:keepSideRatio1];
    CGSize viewSize2 = [self sizeOfView:contentView2
                               thatFits:CGSizeMake(contentWidth2, contentRect.size.height)
                          keepSideRatio:keepSideRatio2];
    CGFloat spaceWidth = (kAlertViewWidth - viewSize1.width - viewSize2.width) / spacesCount;
    if (contentView1)
    {
        contentView1.frame = CGRectMake(spaceWidth,
                                       contentRect.origin.y + (contentRect.size.height - viewSize1.height) * 0.5f,
                                       viewSize1.width,
                                       viewSize1.height);
        contentView1.tag = kTagConventView;
        [alertView addSubview:contentView1];
    }
    if (contentView2)
    {
        contentView2.frame = CGRectMake(spaceWidth * 2.0 + viewSize1.width,
                                        contentRect.origin.y + (contentRect.size.height - viewSize2.height) * 0.5f,
                                        viewSize2.width,
                                        viewSize2.height);
        contentView2.tag = kTagConventView + 1;
        [alertView addSubview:contentView2];
    }
    TouchDetecterView * touchDetector = [TouchDetecterView view];
    if (confirmButtonTitle.length > 0)
    {
        touchDetector.zonesCount = 2;
    }
    touchDetector.frame = CGRectMake(spaceWidth,
                                     contentRect.origin.y + contentRect.size.height,
                                     contentRect.size.width,
                                     50.0f);
    touchDetector.backgroundColor = [UIColor clearColor];
    touchDetector.delegate = alertView;
    [alertView addSubview:touchDetector];
    return alertView;
}

- (UIView *) contentView1
{
    return [self viewWithTag:kTagConventView];
}

- (UIView *) contentView2
{
    return [self viewWithTag:kTagConventView + 1];
}

+ (UIAlertView *) alertViewWithIcon: (UIImage *) icon
                          iconRatio: (CGFloat) iconRatio
                              title: (NSString *) title
                            message: (NSString *) message
                           delegate: (id) delegate
                  cancelButtonTitle: (NSString *) cancelButtonTitle
                 confirmButtonTitle: (NSString *) confirmButtonTitle
{
    UIImageView * imageView = [[[UIImageView alloc] initWithImage:icon] autorelease];
    imageView.backgroundColor = [UIColor clearColor];
    
    UILabel * messageLabel = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.shadowColor = [UIColor blackColor];
    messageLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.text = message;
    UIAlertView * alertView = [UIAlertView alertViewWithTitle:title
                                                 contentView1:imageView
                                               keepSideRatio1:YES
                                                 contentView2:messageLabel
                                               keepSideRatio2:NO
                                                contentsRatio:iconRatio
                                                     delegate:delegate
                                            cancelButtonTitle:cancelButtonTitle
                                           confirmButtonTitle:confirmButtonTitle];
    return alertView;
}

@end
