//
//  ScaryBugDatabase.h
//  ScaryBugs
//
//  Created by Ray Wenderlich on 8/25/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugDatabase : NSObject {

}

+ (NSMutableArray *)loadScaryBugDocs;
+ (NSString *)nextScaryBugDocPath;
+ (NSMutableArray *)importableScaryBugDocs;

@end
