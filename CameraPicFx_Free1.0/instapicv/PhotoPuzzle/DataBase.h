//
//  DataBase.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 8/15/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject
+(void)checkAndCreateDatabase;
+(void)AddPuzzle:(NSString *)user_id puzzleImage:(NSData *)image Font_Selection:(NSString *)Font_Selection Text_Place:(NSString *)Text_Place Complexity_Level:(NSString *)Complexity_Level Text:(NSString *)Text;
+(void)UpdatePuzzle:(NSString *)user_id Font_Selection:(NSString *)Font_Selection Text_Place:(NSString *)Text_Place Complexity_Level:(NSString *)Complexity_Level Text:(NSString *)Text ID:(int)ID;
+(NSMutableArray*)viewAllPuzzle:(NSString *)user_id;
@end
