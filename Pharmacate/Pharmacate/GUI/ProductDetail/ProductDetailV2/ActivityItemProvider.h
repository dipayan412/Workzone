//
//  ActivityItemProvider.h
//  Pharmacate
//
//  Created by Dipayan Banik on 9/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailV2PanelView.h"

@interface ActivityItemProvider : UIActivityItemProvider <UIActivityItemSource>

@property(nonatomic, strong) UIActivityViewController *activityController;
@property(nonatomic, strong) NSString *imageLink;

@end
