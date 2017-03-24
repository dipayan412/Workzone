//
//  LoginDelegate.h
//  RenoMate
//
//  Created by Nazmul Quader on 3/12/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate <NSObject>

-(void)facebookSucceededLogin;
-(void)facebookFailedLogin;

@end
