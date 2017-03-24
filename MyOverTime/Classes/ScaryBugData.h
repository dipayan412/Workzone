//
//  ScaryBugData.h
//  ScaryBugs
//
//  Created by Ray Wenderlich on 8/24/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject <NSCoding> {
    NSString *_title;
    //float _rating;
}

@property (copy) NSString *title;
//@property  float rating;

- (id)initWithTitle:(NSString*)title; //rating:(float)rating;

@end
