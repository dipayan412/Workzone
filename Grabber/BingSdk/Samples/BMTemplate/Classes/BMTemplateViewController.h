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
//  BMTemplateViewController.h
//  BMTemplate
//

#import <UIKit/UIKit.h>
#import "BingMaps/BingMaps.h"


@interface BMTemplateViewController : UIViewController <BMMapViewDelegate> {
	IBOutlet BMMapView* mapView;
}

@end

