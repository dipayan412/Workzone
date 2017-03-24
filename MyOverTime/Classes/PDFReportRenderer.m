

#import "PDFReportRenderer.h"
#import "CoreText/CoreText.h"
#import "PrintItem.h"
#import "StaticConstants.h"

#define kDefineMaxRowStartPage 20//11
#define kDefineMaxRowNormalPage 23//14
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kHeaderPosition 60
#define kTopHeaderPosition 120
#define kMargin 30
#define kTextMargin 20
#define kTextMarginAdjust 2
#define kRowHeight 10
#define kTableRowHeight 16
#define kMaximumLimit 200
#define kGraphStart 140
#define kGraphArea 400

#define kYAxisPosition 350
#define kScaleX 0.2

#define kTableGap 200
#define kXOrigin 305
#define kResultRowHeight 60

#define kPageGap 30

#define kMaximum 480


@implementation PDFReportRenderer

+(void) drawStartOfSection:(PrintItem*) item atPosition:(NSInteger) positionY{
    
    
    int xOrigin = kMargin;
    int tableGap=kTableGap;
    
    //Lines
    [self drawDoubleLineAt:CGPointMake(kMargin, positionY+3) withRowHeight:14 andColumnWidth:300 andRowCount:1 andColumnCount:2];
    [self drawText:@"YES/NO" inFrame:CGRectMake(xOrigin+tableGap, positionY+17, 200, kRowHeight) ofType:2];
        
    
}


+(void)drawPDF:(NSString*)fileName forArray:(NSMutableDictionary *) listDictionary andHeaderText:(NSString *) stringHeader andAdjust:(BOOL) adjust
{
    if ([[listDictionary allKeys] count]==0)
    {
        return;
    }
    if (stringHeader==nil)
    {
        //stringHeader=@"Report";
    }
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    
    //[self drawLogo];
   // int xOrigin = 20;
    //int xoriginNext=290;
    
    
    int tableGap=kTableGap;
    
    NSInteger currentPage = 0;
    BOOL done=NO;
    int pageCount=[[listDictionary allKeys] count];
    NSInteger counter=0;
    int positionY=0;
    do {
        currentPage++;
        NSMutableArray *array=[listDictionary objectForKey:[NSString stringWithFormat:@"%d",currentPage]];
        counter++;
       // int position=0;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        positionY=30;
        //position=positionY;
        [self drawPageNumber:currentPage];
        
        for (int i=0;i<[array count];i++)
        {
            PrintItem *printItem=[array objectAtIndex:i];
            
        if (printItem.kindOfItem==kKindSectionFirstPage)
        {
            [self drawTextHeader:printItem.mainTitle inFrame:CGRectMake(printItem.xPosition, printItem.yPosition, kDefaultPageWidth-2*kPageGap, kTableRowHeight)  ofType:2];
            }
           else if (printItem.kindOfItem==kKindSectionRowUser)
           {
                [self drawTextHeader:printItem.mainTitle inFrame:CGRectMake(printItem.xPosition, printItem.yPosition, kDefaultPageWidth-2*kPageGap, kTableRowHeight)  ofType:2];
            }
           else if (printItem.kindOfItem==kKindSectionRow)
           {
                [self drawText:printItem.text1 inFrame:CGRectMake(printItem.xPosition, printItem.yPosition+2, 200, kRowHeight) ofType:0];
               
                if (printItem.isGraphical)
                {
                    //CGFloat factor=(500)/(100);
                    
                    CGFloat factor=kGraphArea/printItem.widthGraphMaximum;
                    CGFloat barX = printItem.origin;
                    CGFloat barY =  printItem.yPosition-kRowHeight;
                    CGFloat barHeight = kRowHeight;
                    CGFloat barWidth=printItem.widthGraph*factor;

            
                   // NSLog(@"bb %f %f  %f",barX,barWidth,printItem.widthGraphMaximum);

                    if (barWidth<0)
                    {
                        barWidth*=-1;
                        barX-=barWidth;
                    }
                   // NSLog(@"endd %f %f",barX,barWidth);

                    CGRect barRect = CGRectMake(kGraphStart+barX, barY, barWidth, barHeight);
                    //NSLog(@"graph %f %f",barX,barWidth);
                    [self drawBar:barRect];
                    barRect.origin.x=barX+barWidth+10+kGraphStart;
                    barRect.origin.y+=10;

//                    [self drawTitleForText:printItem.text2 atPosition:barRect ];
                    [self drawTitleForText:printItem.text3 atPosition:barRect ];
                    CGPoint from = CGPointMake(kGraphStart+barX, barY);
                    CGPoint to = CGPointMake(kGraphStart+barX, barY+20);
                    [self drawLineFromPoint:from toPoint:to];

            }
            else
            {
                [self drawText:printItem.text2 inFrame:CGRectMake(printItem.xPosition+tableGap, printItem.yPosition+2, 200, kRowHeight) ofType:0];
                 [self drawText:printItem.text3 inFrame:CGRectMake(printItem.xPosition+tableGap+100, printItem.yPosition+2, 200, kRowHeight) ofType:0];
                 [self drawText:printItem.text4 inFrame:CGRectMake(printItem.xPosition+tableGap+200, printItem.yPosition+2, 200, kRowHeight) ofType:0];
            }
                
              
                [self drawTableAt:CGPointMake(kPageGap, printItem.yPosition-2-kRowHeight) withRowHeight:kTableRowHeight andColumnWidth:0 andRowCount:1 andColumnCount:2];
        }
        else if (printItem.kindOfItem==kKindSectionStart)
        {
            [self drawTextHeader:printItem.mainTitle inFrame:CGRectMake(printItem.xPosition, printItem.yPosition, kDefaultPageWidth-2*kPageGap, kTableRowHeight)  ofType:1];
            //Draw Scale
            if (printItem.isGraphical)
            {
                [self drawTextHeader:printItem.text1 inFrame:CGRectMake(kGraphStart, printItem.yPosition, kDefaultPageWidth-2*kPageGap, kTableRowHeight)  ofType:1];
                
                [self drawTextHeader:printItem.text2 inFrame:CGRectMake(kGraphStart+kGraphArea, printItem.yPosition, kDefaultPageWidth-2*kPageGap, kTableRowHeight)  ofType:1];
            }
            else
            {
                int gap=100;
                [self drawTextHeader:printItem.text1 inFrame:CGRectMake(gap+kGraphStart, printItem.yPosition, 200, kTableRowHeight)  ofType:1];

                [self drawTextHeader:printItem.text2 inFrame:CGRectMake(gap+0.5*tableGap+kGraphStart, printItem.yPosition, 200, kTableRowHeight)  ofType:1];
                [self drawTextHeader:printItem.text3 inFrame:CGRectMake(gap+tableGap+kGraphStart, printItem.yPosition, 200, kTableRowHeight)  ofType:1];
            }
            
            int yposGraph=printItem.yPosition-20;
            CGPoint from = CGPointMake(kYAxisPosition, yposGraph);
            CGPoint to = CGPointMake(kYAxisPosition, yposGraph+20);
            //[self drawLineFromPoint:from toPoint:to];
            
            
            from = CGPointMake(kGraphStart, yposGraph);
            to = CGPointMake(kGraphStart, yposGraph+20);
            [self drawLineFromPoint:from toPoint:to];
            
            from = CGPointMake(kGraphStart+kGraphArea, yposGraph);
            to = CGPointMake(kGraphStart+kGraphArea, yposGraph+20);
            [self drawLineFromPoint:from toPoint:to];
        }

    }
        
        if (currentPage==pageCount)
        {
            //NSLog(@"current page %d %d",currentPage,pageCount);
            done=YES;
        }
    } while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}



+ (void)drawTitleForText:(NSString *) theText atPosition:(CGRect) titlePositionFrame
{
    // Drawing text
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSelectFont(context, "Helvetica", 8, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    //CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));//Rotates 90 degree vertical
    
    CGContextShowTextAtPoint(context, titlePositionFrame.origin.x,titlePositionFrame.origin.y, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    
}
+ (void)drawBar:(CGRect)rect 
{
    //Shading
    // Prepare the resources
    CGContextRef ctx = UIGraphicsGetCurrentContext();
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


+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.1, 0.1, 0.1, 0.1};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}

+(void)drawTextHeader:(NSString*)textToDraw inFrame:(CGRect)frameRect  ofType:(NSInteger) type
{
    if (textToDraw==nil) {
        return;
    }
    CFStringRef stringRef = ( CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    
    UIColor *textColor = [UIColor blackColor];
    int fontSize=10;
    if (type==1) {
        textColor=[UIColor blackColor];
        fontSize=10;
    }
    if (type==2) {
        textColor=[UIColor blackColor];
        fontSize=13;
    }
    if (type==3) {
        textColor=[UIColor blackColor];
        fontSize=8;
    }
    CGColorRef color = textColor.CGColor;
    
    
    CTFontRef font = CTFontCreateWithName(CFSTR("Arial-BoldMT"), fontSize, NULL);
    
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    
    
    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName,kCTForegroundColorAttributeName,kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font,color,paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);

}

+(void)drawTextCentralHeader:(NSString*)textToDraw inFrame:(CGRect)frameRect  ofType:(NSInteger) type
{
    if (textToDraw==nil) {
        return;
    }
    CFStringRef stringRef = ( CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    
    
    UIColor *textColor = [UIColor whiteColor];
    if (type==1) {
        textColor = [UIColor blackColor];
    }
    
    CGColorRef color = textColor.CGColor;
    
    CTFontRef font = CTFontCreateWithName(CFSTR("Arial-BoldMT"), 8, NULL);
    
    CTTextAlignment alignment = kCTCenterTextAlignment;
    
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    
    
    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName,kCTForegroundColorAttributeName,kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font,color,paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}



+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect ofType:(NSInteger) type
{
    if (textToDraw==nil) {
        return;
    }
    CFStringRef stringRef = ( CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    
    UIColor *textColor = [UIColor blackColor];
    if (type==1) {
        textColor = [UIColor lightGrayColor];
        
    }
    int fontSIze=7;
    if (type==2) {
        fontSIze=7;
    }
    else if (type==3) {
        fontSIze=9;
    }
    else if (type==4) {
        fontSIze=8;
    }
    else if (type==5) {
        fontSIze=8;
        textColor = [UIColor whiteColor];
        
    }
    
    
    
    CGColorRef color = textColor.CGColor;
    
    CTFontRef font = CTFontCreateWithName(CFSTR("ArialMT"), fontSIze, NULL);
    
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    
    
    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName,kCTForegroundColorAttributeName,kCTParagraphStyleAttributeName };
    CFTypeRef values[] = { font,color,paragraphStyle };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}


+(void)drawHeader:(NSString *) text {
    CGRect frame=CGRectMake(30,kTopHeaderPosition,600,80);
    [self drawText:text inFrame:frame ofType:0];
}

+(void)drawDoubleLineAt:(CGPoint)origin 
          withRowHeight:(int)rowHeight 
         andColumnWidth:(int)columnWidth 
            andRowCount:(int)numberOfRows 
         andColumnCount:(int)numberOfColumns

{
    
    for (int i = 0; i <= numberOfRows; i++) {
        
        int newOrigin = origin.y + (rowHeight*i);
        
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(kDefaultPageWidth-kMargin, newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
        
        
    }
    
}

+(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns

{
    
    //Hor lines
    for (int i = 0; i <= numberOfRows; i++) {
        
        int newOrigin = origin.y + (rowHeight*i);
        if (i>1) {
            // columnWidth=35;
        }
        else {
            // columnWidth=50;
        }
        columnWidth=kDefaultPageWidth-2*kPageGap;
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x +columnWidth, newOrigin);
        
        
        [self drawLineFromPoint:from toPoint:to];
        
        
    }
    //Ver lines
    
    /*for (int i = 0; i <= numberOfColumns; i++) {
        
        if (i>1 && numberOfColumns<=2) {
            columnWidth=25;
        }
        else if (numberOfColumns==4){
            columnWidth=kResultRowHeight;
        }
        else {
            columnWidth=30;
        }
        
        int newOrigin = origin.x + (columnWidth*i);
        
        
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        /// NSLog(@"flinram %f %f",from.x,to.x);
        
        [self drawLineFromPoint:from toPoint:to];
        
        
    }*/
}

+(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns andArray:(NSArray *) allInfo
{
    int padding =5; 
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++) 
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth-2*padding, rowHeight);
            // NSLog(@"fram %f %f",frame.origin.x,frame.size.width);
            
            if ([infoToDraw count]>j) {
                [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame ofType:0];
            }
        }
        
    }
    
    
    
    
}


+(void)drawPageNumber:(NSInteger)pageNum
{
    NSString* pageString = [NSString stringWithFormat:@"%@ %d",PDF_PageNumber, pageNum];
    UIFont* theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(kDefaultPageWidth, 72);
    
    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
    CGRect stringRect = CGRectMake(((kDefaultPageWidth - pageStringSize.width) / 2.0),
                                   735.0 + ((72.0 - pageStringSize.height) / 2.0) ,
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    [pageString drawInRect:stringRect withFont:theFont];
}
@end
