//
//  InAppRageIAPHelper.m
//  inAppRange
//
//  Created by Junaid Akram on 8/17/11.
//  Copyright 2011 Swengg Co. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
//    NSSet *productIdentifiers = [NSSet setWithObjects:@"PhotoPuzzle_up_007",@"PhotoPuzzle_Bottom_007",nil];
    NSSet *productIdentifiers = [NSSet setWithObjects:@"removetopad",@"removebottomadd",nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}


/*- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}*/

@end
