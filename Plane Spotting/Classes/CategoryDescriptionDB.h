//
//  CategoryDescriptionDB.h
//  RenoMate
//
//  Created by yogesh ahlawat on 09/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class reprsenting CatDescrptionTable in DataBase 

@interface CategoryDescriptionDB : NSObject
{
    NSString *name;
    NSString *PhotoRef;
    NSString *notes;
    NSString *location;
    float longitute;
    float latitute;
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *notes;
@property(nonatomic,retain)NSString *location;
@property(nonatomic)float longitute;
@property(nonatomic)float latitute;
@property(nonatomic,retain)NSString *PhotoRef;
@end
