//
//  PlayHavenClass.h
//  PZPlayer
//
//  Created by Granjur on 17/07/2013.
//
//

#import <Foundation/Foundation.h>

@interface PlayHavenClass : NSObject
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

// PlayHaven
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
