//
//  RightViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface RightViewController : UINavigationController
{
    
}

@property(nonatomic, strong) id<DrawerViewDelegate> drawerViewDelegate;

-(void)openDrawerView;
-(void)closeDrawerView;

@end
