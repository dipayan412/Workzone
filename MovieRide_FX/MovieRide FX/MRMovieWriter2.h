//
//  MRMovieWriter.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/17.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRTemplate.h"

@protocol MRMovieWriterDelegate <NSObject>

@required
-(void)movieWriterFinished;

@end

@interface MRMovieWriter2 : NSObject


@property (nonatomic) id<MRMovieWriterDelegate> delegate;


-(id)initWithTemplate:(MRTemplate *)template;
-(void)writeImage:(UIImage *)image atFrame:(NSInteger)frameIndex;
-(void)finish;

-(void)cancelProcess;
-(void)pauseProcees;
-(void)resumeProcees;

@end
