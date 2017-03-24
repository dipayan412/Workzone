//
//  SubscriptionProduct.m
//  IBookMagazine
//
//  Created by Prashant Choudhary on 2/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "SubscriptionProduct.h"

@implementation SubscriptionProduct
@synthesize identifier,priceLocale,productId,validDays;
@synthesize isPurchased;
@synthesize productPurchase;
-(void) dealloc{

    [priceLocale release];
    [identifier release];
    [productPurchase release];
    [super dealloc];

}
@end
