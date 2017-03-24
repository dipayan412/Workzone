//
//  InAppPurchaseManager.h
//  ZepniPravopis
//
//  Created by Nazmul Quader on 3/31/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerTransactionCancelledNotification @"kInAppPurchaseManagerTransactionCancelledNotification"
#define kInAppPurchaseManagerInvalidRestoreNotification @"kInAppPurchaseManagerInvalidRestoreNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

+(InAppPurchaseManager*)getInstance;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
- (void)checkPurchasedItems;

@end
