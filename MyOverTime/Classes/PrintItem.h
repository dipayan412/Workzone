//
//  PrintItem.h
//  Audit
//
//  Created by Prashant Choudhary on 5/9/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum kKindOfItem{
    kKindSectionHeader = 0,
    kKindSectionSubHeader,
    kKindSectionRow,
    kKindSectionTotal,
    kKindSectionSubTotal,
    kKindSectionCommentBox,
    kKindSectionCommentBoxSmall,
    kKindSectionCommentBoxBig,
    kKindSectionStart,
    kKindSectionFirstPage,   
    kKindSectionPassFail,
    kKindSectionResultRow,
    kKindSectionPersonInfo,
    kKindSectionMainHeader,
    kKindSectionResultHeader,
    kKindSectionResultTotal,
    kKindSectionSubHeaderSmall,
    kKindSectionAdditionalRow,
    kKindSectionRowOthers,
    kKindSectionRowOthersTitle,
    kKindSectionRowOthersTitleLeftAligned,
    kKindSectionRowUser
} KindOfItem;


@interface PrintItem : NSObject
@property (nonatomic) NSInteger increment,page;
@property (nonatomic) KindOfItem kindOfItem;
@property (nonatomic,retain) NSString *mainTitle,*subTitle,*text1,*text2,*text3,*text4,*text5,*text6,*text7,*text8,*text9,*text10;
@property (nonatomic) NSInteger xPosition,yPosition,widthGraph;
@property (nonatomic) CGFloat widthGraphMaximum;
@property (nonatomic) CGFloat origin;

@property (nonatomic) BOOL isGraphical;

+ (id)productWithName:(NSString *)mainTitle increment:(NSInteger)increment page:(NSInteger)page kindOfItem:(NSInteger) kindOfItem  xPosition:(NSInteger) xPosition yPosition:(NSInteger)  yPosition;
//-(NSInteger) getIncrementalValue;
@property (nonatomic) BOOL drawSectionTitle;
@end
