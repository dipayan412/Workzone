//
//  MOTLabel.h
//  MyOvertime
//
//  Created by Ashif on 7/10/13.
//
//

#import <UIKit/UIKit.h>

@interface MOTLabel : UILabel

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@property (nonatomic,assign) VerticalAlignment verticalAlignment;

@end