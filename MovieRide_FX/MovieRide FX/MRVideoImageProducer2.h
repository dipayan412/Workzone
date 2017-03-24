//
//  MRVideoImageProducer2.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/05/15.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRVideoImageProducer2 : NSObject

@property (nonatomic) NSString *videoFile;
@property (nonatomic, assign) BOOL rotateImage;

-(MRVideoImageProducer2 *)initWithVideo:(NSString *)videoFile;
-(UIImage *)nextImage;

@end
