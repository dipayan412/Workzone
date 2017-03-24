//
//  DBObject.m
//  MyOvertime
//
//  Created by Ashif on 7/3/13.
//
//

#import "DBObject.h"

@implementation DBObject

@synthesize _data;
@synthesize _fileName;

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(void)dealloc
{
    [_fileName release];
    [_data release];
    
    [super dealloc];
}

@end
