//
//  DottedView.m
//  Scheidung
//
//  Created by Prashant Choudhary on 4/21/11.
//  Copyright 2011 pcasso. All rights reserved.
//

#import "BarView.h"

#define kTextGap 3
#define kTextFont 10
#define kChartHeight 30

#define kMinimumLmit -50
#define kMaximumLimit 50

#define kTextAdjust 100
#define kMaximum 480
#define kChartWidth 170

@implementation BarView
@synthesize width,graphMaximumWidth,origin;
@synthesize widthConverted;

-(void) dealloc
{
    [widthConverted release];
    [super dealloc];
}

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    //Shading
    // Prepare the resources
    CGFloat components[12] = {0.2314, 0.5686, 0.4, 1.0,  // Start color
        0.4727, 1.0, 0.8157, 1.0, // Second color
        0.2392, 0.5686, 0.4118, 1.0}; // End color
    CGFloat locations[3] = {0.0, 0.33, 1.0};
    size_t num_locations = 3;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint = rect.origin;
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    
    
    // Create and apply the clipping path
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    // Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

- (void)drawBarGraphWithContext:(CGContextRef)ctx
{

    titlePosition=0;
  //  CGFloat factor=(self.frame.size.width-50)/(kMaximumLimit-kMinimumLmit);
    
    // Draw the bars
        //Let us say 35 units , -10 to 25, origin is
    if (graphMaximumWidth==0)
    {
        graphMaximumWidth=1;
    }
   // NSLog(@"error %f--%f",width,graphMaximumWidth);

    CGFloat factor=kChartWidth/graphMaximumWidth;
   // CGFloat origin=factor*ABS(graphMaximumWidth);
    CGFloat barX = origin;
    CGFloat barY = 0;
    CGFloat barHeight = kChartHeight;
    CGFloat barWidth=width*factor;
    //NSLog(@"eidth %f",self.frame.size.width);
    if (width<0)
    {
        barWidth*=-1;
        barX-=barWidth;
        //titlePosition=barX-30;
    }
    titlePosition=barX+barWidth+kTextGap;

    //NSLog(@"bb %f %f W:%f----%f" ,barX,barWidth,width,graphMaximumWidth);
        CGRect barRect = CGRectMake(barX, barY, barWidth, barHeight);
        [self drawBar:barRect context:ctx];
}

- (void)drawTitleWithContext:(CGContextRef)context forText:(NSString *) theText
{
    // Drawing text
    CGContextSelectFont(context, "Helvetica", kTextFont, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    //CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));//Rotates 90 degree vertical
    
    CGContextShowTextAtPoint(context, titlePosition,15, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
}

-(void)drawRect:(CGRect)rect
{
    //CGFloat widthTemp=width;
    if (width>kMaximumLimit)
    {
        //width=width/kMaximumLimit;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBarGraphWithContext:context];
    if (widthConverted==nil)
    {
        widthConverted=@"0:00";
    }
    [self drawTitleWithContext:context forText:[NSString stringWithFormat:@"%@",widthConverted]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

@end
