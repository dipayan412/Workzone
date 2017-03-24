//
//  Connection.h
//  Whosin
//
//  Created by Kumar Aditya on 10/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface Connection : NSObject {
	NSString *post;
	NSString *hostString;
	NSData *dataUrl;
	SBJsonParser *parser;
	NSDictionary *dictionary;
	
}
@property (nonatomic,retain) NSString *post;
@property (nonatomic,retain) NSString *hostString;
@property (nonatomic,retain) NSData *dataUrl;
 
-(NSDictionary *)getConnection;
-(NSDictionary *)getLoginConnection:(NSString *)email:(NSString *) password;
 

@end
