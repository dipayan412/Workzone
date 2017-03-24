//
//  DataBaseManager.h
//  RenoMate
//
//  Created by yogesh ahlawat on 09/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDescriptionDB.h"
#import "sqlite3.h"

@interface DataBaseManager : NSObject



-(void)insertCatName:(NSString*)ob;                   // insert values in CatNameTable
-(void)insertCatDescription:(CategoryDescriptionDB *)ob;     // insert values in CatDescription  table
-(NSString *)getDBPath;
-(NSMutableArray *)getCatagoryNames;                         // get list of already created categories
-(void)removeCat:(NSString *)str;                            // remove a category
-(NSMutableArray *)getMatchingCat:(NSString *)str;           // return the searhrd result 
-(NSMutableArray *)getSubCat:(NSString *)str;                // get information of sub category
-(void)removePhoto:(NSString *)str;                          // remove image from the category
-(NSMutableArray *)getMatchingSubCat:(NSString *)searchstring:(NSString *)category;
                                                             // searchinging in sub category
-(void)updateInfo:(CategoryDescriptionDB *)ob;               // update already created data

-(int)returnCount;
-(int)returnCountByCat:(NSString *)cat;

+(DataBaseManager*)getInstance;

@end
