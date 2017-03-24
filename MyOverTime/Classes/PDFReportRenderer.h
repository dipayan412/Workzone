
#import <Foundation/Foundation.h>

@interface PDFReportRenderer : NSObject


//+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

//+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect ofType:(NSInteger) type;
//+(void)drawLabels;

//+(void)drawLogo;

+(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns;

+(void)drawPDF:(NSString*)fileName forArray:(NSMutableDictionary *) listArray andHeaderText:(NSString *) stringHeader andAdjust:(BOOL) adjust;

+(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns andArray:(NSArray *) allInfo;

@end
