//
//  OfferDetailsViewController.h
//  Grabber
//
//  Created by World on 3/19/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromoObject.h"

@interface OfferDetailsViewController : UIViewController
{
    IBOutlet UILabel *shopNameLabel;
    IBOutlet UILabel *promoNameLabel;
    IBOutlet UILabel *promoDetailsLabel;
}
@property (nonatomic, retain) PromoObject *promo;

@end
