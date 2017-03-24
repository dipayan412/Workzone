//
//  singletonClass.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 7/27/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AdWhirlView.h"
//#import "AdWhirlDelegateProtocol.h"
#import "CWLSynthesizeSingleton.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "JREngage.h"
@interface singletonClass : NSObject
{
//    AdWhirlView *adWhrilView;
//    AdWhirlView *adWhrilView1;
    AVAudioPlayer* theAudios;
    AVAudioPlayer* theAudios1;
    NSAutoreleasePool *pool;
    JREngage *jrEngage;
}
CWL_DECLARE_SINGLETON_FOR_CLASS(singletonClass)
//@property(nonatomic,retain)AdWhirlView *adWhrilView;
//@property(nonatomic,retain)AdWhirlView *adWhrilView1;
@property(nonatomic,retain)AVAudioPlayer* theAudios;
@property(nonatomic,retain)AVAudioPlayer* theAudios1;
@property(nonatomic,retain)NSAutoreleasePool *pool;
@property(nonatomic,retain)JREngage *jrEngage;
@end
