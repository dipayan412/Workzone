//
//  DottedView.h
//  Scheidung
//
//  Created by Prashant Choudhary on 4/21/11.
//  Copyright 2011 pcasso. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarView :UIView
{
    CGFloat width,titlePosition,origin;
    BOOL centre;

}
@property (nonatomic)     CGFloat width,graphMaximumWidth,origin;
@property (nonatomic,retain)     NSString *widthConverted;

@end
