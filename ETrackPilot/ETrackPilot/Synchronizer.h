//
//  Synchronizer.h
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBIListener.h"
#import "DWIListener.h"
#import "UWIListener.h"
#import "SyncListener.h"

@interface Synchronizer : NSObject <DBIListener, DWIListener, SyncListener, UWIListener>
{
    BOOL running;
    
    NSMutableArray *InspectionListItemIdArray;
}

@property (nonatomic, assign) BOOL pause;

+(id)getInstance;
-(void)startSynchronizer;
-(void)forgroundSyncForListener:(id)listener;
-(void)forgroundDBIForListener:(id)listener;
-(void)forgroundDWIForListener:(id)listener;
-(void)forgroundUWIForListener:(id)listener;

@end
