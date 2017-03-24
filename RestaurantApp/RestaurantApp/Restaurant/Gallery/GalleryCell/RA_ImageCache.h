//
//  RA_ImageCache.h
//  RestaurantApp
//
//  Created by World on 12/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RA_ImageCache : NSObject
{
    
}

-(void) cacheImage: (NSString *) ImageURLString;
-(UIImage *) getImage: (NSString *) ImageURLString;

@end
