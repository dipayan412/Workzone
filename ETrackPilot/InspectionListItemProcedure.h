//
//  InspectionListItemProcedure.h
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InspectionListItems.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "UserDefaultsManager.h"
#import "AppDelegate.h"

@interface InspectionListItemProcedure : NSObject <ASIHTTPRequestDelegate>
{
    
}


-(void)inspectionListItemForListItemIdentifier:(NSArray*)listItemArray;

@end
