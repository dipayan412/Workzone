//
//  SocialSharingUtil.h
//  Grabber
//
//  Created by shabib hossain on 4/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialSharingUtilDelegate <NSObject>

-(void)openOptionToShareOnInstagramWithImagePath:(NSString *)imagePath;

-(void)totalSharesCompleted:(int)_value;

@end

@interface SocialSharingUtil : NSObject

@property (nonatomic, assign) id <SocialSharingUtilDelegate> delegate;

-(id)initWithViewController:(UIViewController *)vc shareImage:(UIImage *)img imageURL:(NSString *)url shareText:(NSString *)str userLocation:(CLLocation *)loc;

-(void)shareOnFacebook;
-(void)shareOnTwitter;
-(void)shareOnPinterest;
-(void)shareOnInstagram;

-(void)startSharing;

@end
