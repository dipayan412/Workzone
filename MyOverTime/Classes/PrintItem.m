//
//  PrintItem.m
//  Audit
//
//  Created by Prashant Choudhary on 5/9/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "PrintItem.h"

@implementation PrintItem
@synthesize kindOfItem;
@synthesize increment;
@synthesize mainTitle;
@synthesize page;
@synthesize xPosition,yPosition;
@synthesize subTitle;
@synthesize text1,text2,text3,text4,text5;
@synthesize text6,text7,text8,text9,text10;
@synthesize drawSectionTitle;
@synthesize isGraphical;
@synthesize origin;
@synthesize widthGraph,widthGraphMaximum;
+ (id)productWithName:(NSString *)mainTitle increment:(NSInteger)increment page:(NSInteger)page kindOfItem:(NSInteger) kindOfItem  xPosition:(NSInteger) xPosition yPosition:(NSInteger)  yPosition
{
	PrintItem *newProduct = [[[self alloc] init] autorelease];
    newProduct.mainTitle=mainTitle;
	newProduct.increment = increment;
    newProduct.page=page;
    newProduct.kindOfItem=kindOfItem;
    newProduct.xPosition=xPosition;
    newProduct.yPosition=yPosition;
    
	return newProduct;
}



-(NSInteger) increment{
    NSInteger incrementVal=12;
    if (kindOfItem==kKindSectionHeader) {
        incrementVal=20;///SECTION HEADER
    }
    else if (kindOfItem==kKindSectionSubHeader) {
        incrementVal=17;
    }
    else if (kindOfItem==kKindSectionStart) {
        incrementVal=13;
    }
    else if (kindOfItem==kKindSectionRow) {
        incrementVal=10;
    } 
    else if (kindOfItem==kKindSectionTotal) {
        incrementVal=15;
    }
    else if (kindOfItem==kKindSectionSubTotal) {
        incrementVal=15;
    }
    else if (kindOfItem==kKindSectionCommentBox) {
        incrementVal=120;
    }
    else if (kindOfItem==kKindSectionCommentBoxBig) {
        incrementVal=345;
    }
    else if (kindOfItem==kKindSectionCommentBoxSmall) {
        incrementVal=80;
    }

return incrementVal;
}
@end
