//
//  Connections.m
//  Whosin
//
//  Created by Kumar Aditya on 10/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "Connections.h"
#import "JSON.h"


@implementation Connections
@synthesize  post;
@synthesize hostString;
@synthesize dataUrl;
int *arr;
  SBJsonParser *parser;
NSArray *array;

-(NSDictionary *)getConnection
{   
    hostString = @"http://qlyfedev.com/services/api/rest/json/?";
	hostString = [hostString stringByAppendingString:post];
	dataUrl =  [NSData dataWithContentsOfURL:[NSURL URLWithString: hostString]];  
	NSString *responseString = [[NSString alloc] initWithData:dataUrl encoding:NSUTF8StringEncoding];
	NSLog(@"hostString is%@",hostString);
	//NSLog(@"dataUrl is%@",dataUrl);
	NSLog(@"responseString = %@",responseString);
	parser = [[SBJsonParser alloc] init];
	dictionary = [parser objectWithString:responseString ];
	return   dictionary;
}

-(NSDictionary *)getLoginConnection:(NSString *)email:(NSString *)password
{    
	post =[NSString stringWithFormat:@"method=auth.getuser&username=%@&password=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&device=&version=21",email,password];
	return [self getConnection];
}

-(NSDictionary *)getSigninConnection:(NSString *)email:(NSString *)password:(NSString *)firstname:(NSString *)lastname:(NSString *)gender:(NSString *)dateofbirth
{
	post=[NSString stringWithFormat:@"method=auth.registeruser&email=%@&password=%@&firstname=%@&lastname=%@&gender=%@&birthdate=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&device=&version=21",email,password,firstname,lastname,gender,dateofbirth];
	return [self getConnection];
}

-(NSDictionary *)getNearByCommunities:(NSString *)latitute:(NSString *)longitute:(NSString *)distance
{
	post =[NSString stringWithFormat:@"method=objects.nearby&lat=%@&lng=%@&dist=%@&subtypes=&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21",latitute,longitute,distance]; 
	return [self getConnection];
}

-(NSDictionary *)getCommunityHome:(NSString *)guid:(NSString *)authToken
{
	      post =[NSString stringWithFormat:@"method=river.get&guid=%@&limit=10&offset=0&after=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",guid,authToken];
		  return [self getConnection];
}

-(NSArray *)getMyCommunity:(NSString *)token
{
	NSString *string=[NSString stringWithFormat:@"http://qlyfedev.com/services/api/rest/json/?method=objects.affiliated&limit=999&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",token];
	NSData *request = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
	NSString *responseString = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
	NSLog(@"responseString = %@",string);
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *feed = [parser objectWithString:responseString ];
	
	NSLog(@"string result:  %@",[feed valueForKey:@"result"]);
	//NSMutableString *text = [NSMutableString stringWithString:@"name"];
	
	NSArray *array1= (NSArray *)[feed valueForKey:@"result"];
	array=(NSArray *)[array1 valueForKey:@"guid"]; 	 
	
	//NSLog(@"value of guid in connection=%@",(NSString *)[arr objectAtIndex:0]);
	 
	return array;
     
}
 

-(NSDictionary *)getAddedCommunity:(NSString *)authToken
{
	post =[NSString stringWithFormat:@"method=objects.affiliated&limit=999&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
}

-(IBAction)getDisconnect:(NSString *)guid:(NSString *)authToken
{ 
	NSString *string=[NSString stringWithFormat:@"http://qlyfedev.com/services/api/rest/json/?method=object.disconnect&guid=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",guid,authToken];
	NSData *request = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
	NSString *responseString = [[NSString alloc] initWithData:request encoding:NSUTF8StringEncoding];
	NSLog(@"responseString = %@",responseString);
	 
}
-(NSDictionary *)getPeopleAtCommunity:(NSString *)guid:(NSString *)authToken
{
  
	post =[NSString stringWithFormat:@"method=object.people&guid=%@&limit=10&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",guid,authToken];
	return [self getConnection];

}
-(NSDictionary *)getAboutMe:(NSString *)guid:(NSString *)message:(NSString *)authToken
{
	 	post =[NSString stringWithFormat:@"method=object.set_status&guid=11&status=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",guid,message,authToken];
	return [self getConnection];
	
}

-(NSDictionary *)getNewComments:(NSString *)authToken
{
	 	
	post =[NSString stringWithFormat:@"method=user.get_notifications&limit=10&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
	
}
-(NSDictionary *)getWave:(NSString *)authToken
{
	 
	post =[NSString stringWithFormat:@"method=user.get_notifications&limit=10&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
	
}

-(NSDictionary *)getMessages:(NSString *)authToken
{    
 	post =[NSString stringWithFormat:@"method=user.get_mail&limit=10&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
	
}

-(NSDictionary *)getNumberActivtity:(NSString *)authToken
{   
 	post =[NSString stringWithFormat:@"method=user.count_notifications&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
	
}

-(NSDictionary *)getUserComments:(NSString *)guid:(NSString *)authToken
{    
 	post =[NSString stringWithFormat:@"method=river.get_item&guid=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",guid,authToken];
	return [self getConnection];
	
}
-(NSDictionary *)postComment:(NSString *)message:(NSString *)guid:(NSString *)authToken
{     
 	post =[NSString stringWithFormat:@"method=object.comment&guid=27&comment=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",message,guid,authToken];
	return [self getConnection];
	
}
 -(NSDictionary *)getAllWave:(NSString *)authToken
{    
 	post =[NSString stringWithFormat:@"method=user.get_waves&limit=10&offset=0&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",authToken];
	return [self getConnection];
	
}
-(NSDictionary *)postWaveBack:(NSString *)ownerGuid:(NSString *)subjectGuid:(NSString *)authToken
{   
 	post =[NSString stringWithFormat:@"method=user.wave&user_guid=%@&subject_guid=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",ownerGuid,subjectGuid,authToken];
	return [self getConnection];
	
}
-(NSDictionary *)postMessageBack:(NSString *)ownerGuid:(NSString *)subjectGuid:(NSString *)message:(NSString *)authToken
{   
 	post =[NSString stringWithFormat:@"method=user.send_mail&user_guid=%@&subject_guid=%@&message=%@&api_key=9c821abb8f349e80908875e28f89f116b1bf6abc&device=&version=21&auth_token=%@",ownerGuid,subjectGuid,message,authToken];
	return [self getConnection];
	
}
@end
