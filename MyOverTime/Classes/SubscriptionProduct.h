//
//  SubscriptionProduct.h
//  IBookMagazine
//
//  Created by Prashant Choudhary on 2/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SubscriptionProduct : NSObject
@property (nonatomic,retain) NSString *identifier;
@property (nonatomic) NSInteger productId,validDays;
@property (nonatomic,retain) NSString *priceLocale;
@property (nonatomic,retain) SKProduct *productPurchase;

@property (nonatomic) BOOL isPurchased;

@end
