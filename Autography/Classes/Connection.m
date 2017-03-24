//
//  Connection.m
//  Whosin
//
//  Created by Kumar Aditya on 10/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "Connection.h"
#import "JSON.h"


@implementation Connection
@synthesize  post;
@synthesize hostString;
@synthesize dataUrl;

-(NSDictionary *)getConnection
{ 
    hostString = @"http://qlyfedev.com/services/api/rest/json/?";
	hostString = [hostString stringByAppendingString:post];
	dataUrl =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostString ]];  
	NSString *responseString = [[NSString alloc] initWithData:dataUrl encoding:NSUTF8StringEncoding];
	NSLog(@"query is%@",hostString);
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
 
@end

 