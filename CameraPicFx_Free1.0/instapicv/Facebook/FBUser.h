//
//  FBUser.h
//  WeatherClock
//
//  Created by shabib hossain on 9/1/13.
//
//

#import <Foundation/Foundation.h>

@protocol FBUser <NSObject>

-(void)facebookDidLogin;
-(void)faceBookDidNotLogin;
-(void)faceBookDidLogOut;

@end
