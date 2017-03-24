//
//  MRProcessingViewController.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCompositor2.h"
#import "MRTemplate.h"
#import "MRProduct.h"
#import <iAd/iAd.h>

@interface MRProcessingViewController : UIViewController <MRComposerDelegate, ADBannerViewDelegate>
{
    IBOutlet UIImageView *processedImageView;
}

@property (nonatomic, assign) BOOL rotateImage;
@property (nonatomic) MRTemplate *template;
@property (nonatomic) MRProduct *product;
@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;
@property (weak, nonatomic) IBOutlet ADBannerView *advertView;

-(IBAction)cancelProcess:(id)sender;

@end
