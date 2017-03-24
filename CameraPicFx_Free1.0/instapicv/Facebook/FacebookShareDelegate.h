//
//  FacebookShareDelegate.h
//  WeatherClock
//
//  Created by shabib hossain on 9/1/13.
//
//

#import <Foundation/Foundation.h>

@protocol FacebookShareDelegate <NSObject>

-(void)facebookShareDidFinishWithSuccess:(BOOL)_success;
-(void)faceBookDidNotLoginFromController;
-(void)faceBookDidLogOutFromController;

@end
