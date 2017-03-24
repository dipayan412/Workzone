//
//  NearbyLocation.h
//  RenoMate
//
//  Created by Nazmul Quader on 3/11/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyLocation : NSObject
{
}

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, retain) NSString *vicinity;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *icon;

-(NSComparisonResult)compareLocationByName:(NearbyLocation*)otherLocation;

@end
