//
//  MRPurchaseViewController.h
//  MovieRide FX
//
//  Created by Ashif on 3/5/14.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProduct.h"

@interface MRPurchaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *videoPlaceholderView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic) MRProduct *product;

-(IBAction)initiatePurchase:(id)sender;

@end
