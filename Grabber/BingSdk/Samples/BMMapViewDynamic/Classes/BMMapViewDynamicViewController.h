//*********************************************************
//
//    Copyright (c) 2011 Microsoft Corporation. All rights reserved.
//    This code is licensed under the Microsoft Public License.
//    THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
//    ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
//    IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
//    PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
//*********************************************************
//
//  BMMapViewDynamicViewController.h
//  BMMapViewDynamic


#import <UIKit/UIKit.h>
#import <BingMaps/BingMaps.h>

@interface BMMapViewDynamicViewController : UIViewController<BMMapViewDelegate> {
	BMMapView *mapView ;
}

@property (nonatomic,retain) BMMapView *mapView;

@end

