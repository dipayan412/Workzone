//
//  FacebookShareDelegate.h
//  CrazyFliesTest
//
//  Created by Ashif Iqbal on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookShareDelegate <NSObject>

-(void)facebookShareDidFinishWithSuccess:(BOOL)_success;
-(void)faceBookDidNotLoginFromController;
-(void)faceBookDidLogOutFromController;

@end
