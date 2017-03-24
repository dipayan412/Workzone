//
//  Connections.h
//  Whosin
//
//  Created by Kumar Aditya on 10/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface Connections : NSObject {
	NSString *post;
	NSString *hostString;
	NSData *dataUrl;
     
	NSDictionary *dictionary;
	
}
@property (nonatomic,retain) NSString *post;
@property (nonatomic,retain) NSString *hostString;
@property (nonatomic,retain) NSData *dataUrl;

-(NSDictionary *)getConnection;
-(NSDictionary *)getLoginConnection:(NSString *)email:(NSString *) password;
-(NSDictionary *)getSigninConnection:(NSString *)email:(NSString *)password:(NSString *)firstname:(NSString *)lastname:(NSString *)gender:(NSString *)dateofbirth;
-(NSDictionary *)getNearByCommunities:(NSString *)latitute:(NSString *)longitute:(NSString *)distance;
-(NSDictionary *)getCommunityHome:(NSString *)guid:(NSString *)authToken;
-(NSArray *)getMyCommunity:(NSString *)token;
-(NSDictionary *)getAddedCommunity:(NSString *)authToken;   
-(IBAction)getDisconnect:(NSString *)guid:(NSString *)authToken;
-(NSDictionary *)getPeopleAtCommunity:(NSString *)guid:(NSString *)authToken;

-(NSDictionary *)getNewComments:(NSString *)authToken;
-(NSDictionary *)getWave:(NSString *)authToken;
-(NSDictionary *)getMessages:(NSString *)authToken;
-(NSDictionary *)getNumberActivtity:(NSString *)authToken;
-(NSDictionary *)getUserComments:(NSString *)guid:(NSString *)authToken;
-(NSDictionary *)postComment:(NSString *)message:(NSString *)guid:(NSString *)authToken;
-(NSDictionary *)getAllWave:(NSString *)authToken;
-(NSDictionary *)postWaveBack:(NSString *)ownerGuid:(NSString *)subjectGuid:(NSString *)authToken;
-(NSDictionary *)postMessageBack:(NSString *)ownerGuid:(NSString *)subjectGuid:(NSString *)message:(NSString *)authToken;

@end
