//
//  FBUser.h
//  CrazyFliesTest
//
//  Created by Ashif Iqbal on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBUser <NSObject>

-(void)facebookDidLogin;
-(void)faceBookDidNotLogin;
-(void)faceBookDidLogOut;

@end
