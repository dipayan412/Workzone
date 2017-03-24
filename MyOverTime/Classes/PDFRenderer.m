

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
#import "StaticConstants.h"

#define kDefaultRowHeight   30    

#define kPageHeight_A4_Portrait 792
#define kPageWidth_A4_Portrait  612

#define kPageHeight_A4_Landscape    612
#define kPageWidth_A4_Landscape     792

#define kHeaderPosition 60
#define kTopHeaderPosition 120

@implementation PDFRenderer

+(void)drawPDF:(NSString*)fileName
      forArray:(NSArray *)listArray
 andHeaderText:(NSString *)stringHeader
andAdjust:(BOOL) adjust
   orientation:(PDFPageOrientation)orientation
{
    if ([listArray count]==0)
    {
        return;
    }
    
    if (stringHeader == nil)
    {
        //stringHeader=@"Report";
    }
    
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    
    int pageWidth = (orientation == PageOrientation_Landscape) ? kPageWidth_A4_Landscape : kPageWidth_A4_Portrait;
    int pageHeight = (orientation == PageOrientation_Landscape) ? kPageHeight_A4_Landscape : kPageHeight_A4_Portrait;
    
    int xOrigin = 20;
    int yOrigin = 100;
    int drawableHeight = pageHeight - yOrigin;
    
    int numberOfRows;
    int numberOfColumns = [[listArray objectAtIndex:0] count];
    int columnWidth = (pageWidth - 2 * xOrigin) / numberOfColumns;
    
    NSInteger currentPage = 0;
    BOOL done = NO;
    int pageCount = 0;
    int defineMaxRowStartPage = (drawableHeight - 90) / kDefaultRowHeight;
    if (adjust == YES)
    {
        defineMaxRowStartPage = drawableHeight / kDefaultRowHeight;
        yOrigin = kHeaderPosition;
    }
    
    int defineMaxRowNormalPage = (drawableHeight - 90) / kDefaultRowHeight;
    if ([listArray count] <= defineMaxRowStartPage)
    {
        pageCount = 1;
    }
    else
    {
        pageCount = (listArray.count - defineMaxRowStartPage) / defineMaxRowNormalPage + 2;
    }
    
    do
    {
        int start = defineMaxRowStartPage + (currentPage - 1) * defineMaxRowNormalPage;
        int pageRange = defineMaxRowNormalPage - 1;
        if (currentPage == 0)
        {
            start = defineMaxRowStartPage * currentPage;
            pageRange = defineMaxRowStartPage - 1;
        }
        
        int end = start + pageRange;
        NSMutableArray *pageItems = [[NSMutableArray alloc]init ];
        for (int i = start;i <= end; i++)
        {
            if ([listArray count] > i)
            {
                [pageItems addObject:[listArray objectAtIndex:i]];
            }
        }

        currentPage++;
    
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageWidth, pageHeight), nil);
    
        if (currentPage == 1)
        {
            [self drawHeader:stringHeader];
         
            numberOfRows = defineMaxRowStartPage;
            if ([listArray count] < numberOfRows)
            {
                numberOfRows = [listArray count];
            }
        }
        else
        {
            numberOfRows=defineMaxRowNormalPage;
            if ([pageItems count]<numberOfRows)
            {
                numberOfRows=[pageItems count];
            }
          
            yOrigin = kHeaderPosition;
        }
        
        [self drawPageNumber:currentPage forOrientation:orientation];
        [self drawTableAt:CGPointMake(xOrigin, yOrigin) withRowHeight:kDefaultRowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
       
    
        [self drawTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:kDefaultRowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns andArray:pageItems];
        if (currentPage==pageCount)
        {
            done=YES;
        }
    } while (!done);

    UIGraphicsEndPDFContext();
}


+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
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

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    if (textToDraw==nil)
    {
        return;
    }
     CFStringRef stringRef = ( CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CTFontRef font = CTFontCreateWithName(CFSTR("ArialMT"), 8, NULL);

    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
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


+(void)drawHeader:(NSString *) text
{
    CGRect frame = CGRectMake(30, kTopHeaderPosition, 600, 80);
    [self drawText:text inFrame:frame];
}

+(void)drawLabels
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews])
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
            [self drawText:label.text inFrame:label.frame];
        }
    }
    
}

+(void)drawLogo
{
    return;
    
    UIImage* logo = [UIImage imageNamed:@"Icon.png"];
    [self drawImage:logo inRect:CGRectMake(520, 10, 57, 57)];
}

+(void)drawTableAt:(CGPoint)origin 
    withRowHeight:(int)rowHeight 
   andColumnWidth:(int)columnWidth 
      andRowCount:(int)numberOfRows 
   andColumnCount:(int)numberOfColumns

{
   
    for (int i = 0; i <= numberOfRows; i++)
    {
        int newOrigin = origin.y + (rowHeight*i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);

        [self drawLineFromPoint:from toPoint:to];
    }
    
    for (int i = 0; i <= numberOfColumns; i++)
    {
        int newOrigin = origin.x + (columnWidth*i);
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));

        [self drawLineFromPoint:from toPoint:to];
    }
}

+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
              andArray:(NSArray *) allInfo
{
    int padding = 5; 
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++) 
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding,
                                      newOriginY + padding,
                                      columnWidth - 2 * padding,
                                      rowHeight);

            if ([infoToDraw count] > j)
            {
                [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            }
        }
    }
}

+(void)drawPageNumber:(NSInteger)pageNum forOrientation:(PDFPageOrientation)orientation
{
    NSString* pageString = [NSString stringWithFormat:@"%@ %d", PDF_PageNumber, pageNum];
    UIFont* theFont = [UIFont systemFontOfSize:12];
    
    int pageWidth = (orientation == PageOrientation_Landscape) ? kPageWidth_A4_Landscape : kPageWidth_A4_Portrait;
    
    CGSize maxSize = CGSizeMake(pageWidth, 72);

    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
    CGRect stringRect = CGRectMake(((pageWidth - pageStringSize.width) / 2.0),
                                   735.0 + ((72.0 - pageStringSize.height) / 2.0) ,
                                   pageStringSize.width,
                                   pageStringSize.height);

    [pageString drawInRect:stringRect withFont:theFont];
}

@end
