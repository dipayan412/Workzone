//
//  MRPreviewViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProduct.h"

@interface MRPreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *videoPlaceholderView;
@property (nonatomic) MRProduct *product;


@end
