
#import <Foundation/Foundation.h>

typedef enum{
    PageOrientation_Portrait = 0,
    PageOrientation_Landscape
}PDFPageOrientation;


@interface PDFRenderer : NSObject


//+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels;

+(void)drawLogo;

+(void)drawPDF:(NSString*)fileName
      forArray:(NSArray *)listArray
 andHeaderText:(NSString *)stringHeader
     andAdjust:(BOOL) adjust
   orientation:(PDFPageOrientation)orientation;

+(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns;



+(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns andArray:(NSArray *) allInfo;

@end
