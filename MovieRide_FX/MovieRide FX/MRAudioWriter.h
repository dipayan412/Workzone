//
//  MRAudioWriter.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/22.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRAudioWriterDelegate <NSObject>

@required
-(void)audioWriterFinished;

@end

@interface MRAudioWriter : NSObject

@property (nonatomic) id<MRAudioWriterDelegate> delegate;

-(void)addAudio:(NSURL *)audioUrl toVideo:(NSURL *)videoUrl;

@end
