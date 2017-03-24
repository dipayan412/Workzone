//
//  Neocortex.h
//  Neocortex SDK
//
//  Created by Osama A. Zakaria on 9/1/2012.
//  Copyright (c) 2012 Kayabit, Inc. All rights reserved.
//

#ifndef NeocortexHelpers_h
#define NeocortexHelpers_h


//Neocortex Constants

typedef struct ChartboostSettings {
	NSString* appID;
	NSString* appSignature;
} ChartboostSettings;

typedef struct RevmobSettings {
	NSString* appID;
} RevmobSettings;

typedef struct MopubSettings {
	NSString* adUnitIDBanner;
	NSString* adUnitIDMedium;
	NSString* adUnitIDFullscreen;
} MopubSettings;

typedef struct TapjoySettings {
	NSString* appID;
	NSString* appSecretKey;
} TapjoySettings;

typedef struct FlurrySettings {
	NSString* appID;
} FlurrySettings;

typedef struct CustomPopupSettings {
	NSString *title;
	NSString *message;
	NSString *cancelButtonText;
	NSString *okButtonText;
	NSArray *urls;
} CustomPopupSettings;

//Neocortex Setup

typedef struct AdItemSettings {
	NSMutableArray* pool;
	int showAfterCount;
	int counter;
} AdItemSettings;


#endif
