//
//  GLLVisit.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GLLVisit : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * hasPhoto;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSNumber * remoteId;
@property (nonatomic, retain) NSNumber * rowStatus;

@end
