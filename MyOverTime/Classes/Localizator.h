//
//  Localizator.h
//  MyOvertime
//
//  Created by Kostia on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localizator : NSObject

+ ( NSStringEncoding ) encodingForActiveLanguage;

+ ( NSData * ) encodedDataFromString: ( NSString * ) string;

+ ( NSData * ) encodedDataFromString: ( NSString * ) string
                        withEncoding: ( NSStringEncoding ) encoding;

+ ( NSString * ) charsetForActiveLanguage;

+ ( NSString * ) localeIdentifierForActiveLanguage;

+ (NSString*) dateFormatForActiveLanguage;

@end
