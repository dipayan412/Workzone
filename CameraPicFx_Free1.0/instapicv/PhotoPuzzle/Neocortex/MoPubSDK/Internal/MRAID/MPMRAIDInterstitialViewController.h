//
//  MPMRAIDInterstitialViewController.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MPInterstitialViewController.h"

#import "MRAdView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MPMRAIDInterstitialViewControllerDelegate;
@class MPAdConfiguration;

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MPMRAIDInterstitialViewController : MPInterstitialViewController <MRAdViewDelegate>
{
    MRAdView *_interstitialView;
    MPAdConfiguration *_configuration;
    BOOL _advertisementHasCustomCloseButton;
}

- (id)initWithAdConfiguration:(MPAdConfiguration *)configuration;
- (void)startLoading;

@end

