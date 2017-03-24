//
//  InAppPurchaseManager.h
//  ZepniPravopis
//
//  Created by Nazmul Quader on 3/31/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

#import "GlobalFunctions.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerTransactionCancelledNotification @"kInAppPurchaseManagerTransactionCancelledNotification"
#define kInAppPurchaseManagerRestoreCompleteNotification @"kInAppPurchaseManagerRestoreCompleteNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
@property (nonatomic,retain)     NSMutableArray *productArray;
@property (nonatomic, assign) BOOL productInitializationDone;

+(InAppPurchaseManager*)getInstance;

-(void) createInAppProducts;

- (void)loadStoreForPruduct:(ProductType)_productType;
- (BOOL)canMakePurchases;
- (void)purchaseDaysLimit;
- (void)purchaseExportData;
- (void)purchaseDropbox;
- (void)checkPurchasedItems;

@end
