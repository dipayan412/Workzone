//
//  ALSharedData.h
//  PZPlayer
//
//  Created by Granjur on 13/07/2013.
//
//

#import <Foundation/Foundation.h>
#import "AppLovinClass.h"
#import "PlayHavenClass.h"

@interface ALSharedData : NSObject
{
    // AppLovin
    
    AppLovinClass * appLovinInfoObj;        // Load all values
    
    // PlayHaven
    
    PlayHavenClass * playHavenInfoObj;
}

// AppLovin
@property (nonatomic, retain) AppLovinClass * appLovinInfoObj;

// AppLovin
+(id) getSharedInstance;
+(void) releaseSharedInstance;

- (BOOL) readAppLovinPlistFromServer;
- (void) loadAppLovinClass:(NSDictionary*)dicitonary;
- (NSString*) loadAppLovinURL;
- (NSDictionary *) getAppLovinDictionaryWithUrlStr:(NSString*)urlStr;

// PlayHaven
@property (nonatomic, retain) PlayHavenClass * playHavenInfoObj;
- (BOOL) readPlayHavenPlistFromServer;
- (void) loadPlayHavenClass:(NSDictionary*)dicitonary;
- (NSString*) loadPlayHavenURL;
- (NSDictionary *) getPlayHavenDictionaryWithUrlStr:(NSString*)urlStr;

@end
