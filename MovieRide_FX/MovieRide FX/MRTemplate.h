//
//  MRTemplate.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRSequence.h"
#import "MRLayer.h"

@interface MRTemplate : NSObject

@property (nonatomic) NSString *path;
@property (nonatomic) MRSequence *sequence;
@property (nonatomic) NSArray *layers;

+(MRTemplate *)templateFromPath:(NSString *)templatePath;
    
@end
