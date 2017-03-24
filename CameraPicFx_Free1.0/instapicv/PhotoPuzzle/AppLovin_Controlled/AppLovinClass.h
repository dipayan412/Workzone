//
//  AppLovinClass.h
//  PZPlayer
//
//  Created by Granjur on 12/07/2013.
//
//

#import <Foundation/Foundation.h>

@interface AppLovinClass : NSObject
{
    BOOL showOnBecomeActive;
    BOOL showOnLevelsMenu;
    BOOL showOnMainMenu;
    BOOL showOnPauseMenu;
    BOOL showOnPlaying;
    BOOL showOnGameover;
}

@property (nonatomic, assign) BOOL showOnBecomeActive;
@property (nonatomic, assign) BOOL showOnLevelsMenu;
@property (nonatomic, assign) BOOL showOnMainMenu;
@property (nonatomic, assign) BOOL showOnPauseMenu;
@property (nonatomic, assign) BOOL showOnPlaying;
@property (nonatomic, assign) BOOL showOnGameover;

// AppLovin
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
