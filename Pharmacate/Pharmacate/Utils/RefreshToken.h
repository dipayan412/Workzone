//
//  RefreshToken.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshToken : NSObject

+(id)sharedInstance;
-(void)startTimer;

@end
