//
//  InAppPurchaseManager.h
//  ZepniPravopis
//
//  Created by Nazmul Quader on 3/31/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>
#import "MRUtil.h"
#import "MRAlertView.h"
#import "MRProduct.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerTransactionCancelledNotification @"kInAppPurchaseManagerTransactionCancelledNotification"
#define kInAppPurchaseManagerInvalidRestoreNotification @"kInAppPurchaseManagerInvalidRestoreNotification"

@protocol InAppProductDetailsDelegate <NSObject>

-(void)localizedProductPrice:(NSString*)_price;

@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    MRAlertView *loadingView;
    UIImageView *progressImageView;
    UILabel *progressLabel;
    
    id<InAppProductDetailsDelegate> __unsafe_unretained productDetailsDelegate;
}

@property (nonatomic, assign) BOOL productInitializationDone;
@property (nonatomic, unsafe_unretained)  id<InAppProductDetailsDelegate>productDetailsDelegate;
@property (nonatomic) CGRect progressImageMaxFrame;
@property (nonatomic) UIImageView *progressImageView;
@property (nonatomic) UILabel *progressLabel;

+(InAppPurchaseManager*)getInstance;

-(void)getProductDetailsForProduct:(MRProduct *)_product; // get product price initialization method

- (void)loadStoreForPruduct:(MRProduct *)product;
- (BOOL)canMakePurchases;
//- (void)purchaseSpaceWalk2;
//- (void)purchaseSpaceWars1;
//- (void)purchaseTranspodGiant;
//- (void)purchaseMRacer;
- (void)purchaseTemplate;
- (void)checkPurchasedItems;


@end
