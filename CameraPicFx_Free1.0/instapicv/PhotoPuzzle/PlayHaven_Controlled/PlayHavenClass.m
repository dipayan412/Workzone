//
//  PlayHavenClass.m
//  PZPlayer
//
//  Created by Granjur on 17/07/2013.
//
//

#import "PlayHavenClass.h"

@implementation PlayHavenClass

#define ON_BEOME_ACTIVE     @"OnBecomeActive"
#define ON_GAME_OVER        @"OnGameOver"
#define ON_LEVEL_MENU       @"OnLevelsMenu"
#define ON_MAIN_MENU        @"OnMainMenu"
#define ON_PAUSE_MENU       @"OnPauseMenu"
#define ON_PLAYING          @"OnPlaying"

@synthesize showOnBecomeActive, showOnGameover, showOnLevelsMenu, showOnMainMenu, showOnPauseMenu, showOnPlaying;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.showOnBecomeActive     = [[dictionary objectForKey:ON_BEOME_ACTIVE] boolValue];
        self.showOnMainMenu         = [[dictionary objectForKey:ON_MAIN_MENU] boolValue];
        self.showOnLevelsMenu       = [[dictionary objectForKey:ON_LEVEL_MENU] boolValue];
        self.showOnPauseMenu        = [[dictionary objectForKey:ON_PAUSE_MENU] boolValue];
        self.showOnGameover         = [[dictionary objectForKey:ON_GAME_OVER] boolValue];
        self.showOnPlaying          = [[dictionary objectForKey:ON_PLAYING] boolValue];
    }
    return self;
}

@end
