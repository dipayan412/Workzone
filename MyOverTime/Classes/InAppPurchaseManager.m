//
//  InAppPurchaseManager.m
//  ZepniPravopis
//
//  Created by Nazmul Quader on 3/31/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "SubscriptionProduct.h"

#define kInAppPurchaseExportMyData @"com.danielg.appIAP.2"
#define kInAppPurchaseDaysLimit @"com.danielg.appIAP.1"
#define kInAppPurchaseDropBox @"com.danielg.appIAP.4"

@implementation InAppPurchaseManager
@synthesize productArray;
@synthesize productInitializationDone;

static InAppPurchaseManager *instance;

+(InAppPurchaseManager*)getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[super allocWithZone:NULL] init];
        }
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void) createInAppProducts
{
    productArray=[[NSMutableArray alloc]initWithCapacity:10];
    
    SubscriptionProduct *product1=[self makeProductsWithIdentifier:kSubscriptionIdentifier1];
    [productArray addObject:product1];
    
    SubscriptionProduct *product2=[self makeProductsWithIdentifier:kSubscriptionIdentifier2];
    [productArray addObject:product2];
    
    SubscriptionProduct *product3=[self makeProductsWithIdentifier:kSubscriptionIdentifier3];
    [productArray addObject:product3];
    
    [self getProductInfo:productArray];
}

-(SubscriptionProduct *) makeProductsWithIdentifier:(NSInteger ) identifier
{
    NSString *identifierProduct=[NSString stringWithFormat:@"%@%d",kProductIdentifier,identifier];
    SubscriptionProduct *product=[[[SubscriptionProduct alloc]init] autorelease];
    product.identifier=identifierProduct;
    product.productId=identifier;
    
    product.isPurchased=NO;
    product.isPurchased=[GlobalFunctions getProductStatus:identifier];
    
    return product;
}

-(void) getProductInfo:(NSMutableArray *) listArray
{
    if ([SKPaymentQueue canMakePayments])
    {
        
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        for (int i=0;i<[productArray count];i++)
        {
            SubscriptionProduct *product=[productArray objectAtIndex:i] ;
            //int theId=product.productId;
            [temp addObject:product.identifier];
        }
        
        NSSet *productList = [[NSSet alloc] initWithArray:temp];
        
        SKProductsRequest *productReq = [[SKProductsRequest alloc] initWithProductIdentifiers:productList];
        
        [temp release];
        [productList release];
        productReq.delegate = self;
        [productReq start];
        [productReq release];
        
        productInitializationDone = NO;
    } 
}


- (void)requestProductDataForProduct:(ProductType)_product
{
    NSSet *productIdentifiers;
    switch (_product) 
    {
        case ProductTypeDaysLimit:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseDaysLimit, nil];
            
            break;
            
        case ProductTypeExportData:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseExportMyData, nil];
            
            break;
            
        case ProductTypeDropbox:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseDropBox, nil];
            
            break;
            
        default:
            break;
    }
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if(!productInitializationDone)
    {
        productInitializationDone = YES;
        SKProduct *validProduct = nil;
        int count = [response.products count];
        if (count > 0)
        {
            for (int i=0;i<count;i++)
            {
                validProduct = [response.products objectAtIndex:i];
                
                for (int i=0;i< [productArray count];i++)
                {
                    SubscriptionProduct *product=[productArray objectAtIndex:i];
                    if ([[validProduct productIdentifier] isEqualToString: product.identifier])
                    {
                        NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
                        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                        [formatter setLocale:[validProduct priceLocale]];
                        NSString *str = [formatter stringFromNumber:[validProduct price]];
                        product.priceLocale=str;
                        product.productPurchase=validProduct;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPricesAvailable" object:nil];
                    }
                }
            }
        }
        else if (!validProduct)
        {
            NSLog(@"No products available");
        }
    }
    else
    {
        NSArray *products = response.products;
        proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
        if (proUpgradeProduct)
        {
            NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
            NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
            NSLog(@"Product price: %@" , proUpgradeProduct.price);
            NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
        }
        
        for (NSString *invalidProductId in response.invalidProductIdentifiers)
        {
            NSLog(@"Invalid product id: %@" , invalidProductId);
        }
        
        // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
        [productsRequest release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
    }
}

- (void) checkPurchasedItems // Call This Function
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

//Then this delegate Funtion Will be fired
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
    
    if ([purchasedItemIDs containsObject:kInAppPurchaseDaysLimit])
    {
        NSString *identifierTr=kInAppPurchaseDaysLimit;
        NSString *mainId=kProductIdentifier;
        NSInteger identifier=[[identifierTr substringFromIndex:[mainId length]] intValue];
        
        [GlobalFunctions updatePaymentStatus:identifier];
    }
    
    if ([purchasedItemIDs containsObject:kInAppPurchaseExportMyData])
    {
        NSString *identifierTr=kInAppPurchaseExportMyData;
        NSString *mainId=kProductIdentifier;
        NSInteger identifier=[[identifierTr substringFromIndex:[mainId length]] intValue];
        
        [GlobalFunctions updatePaymentStatus:identifier];
    }
    
    if ([purchasedItemIDs containsObject:kInAppPurchaseDropBox])
    {
        NSString *identifierTr=kInAppPurchaseDropBox;
        NSString *mainId=kProductIdentifier;
        NSInteger identifier=[[identifierTr substringFromIndex:[mainId length]] intValue];
        
        [GlobalFunctions updatePaymentStatus:identifier];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerRestoreCompleteNotification object:self userInfo:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    if (error.code == SKErrorPaymentCancelled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionCancelledNotification object:self userInfo:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:nil];
    }
}


//
// call this method once on startup
//
- (void)loadStoreForPruduct:(ProductType)_productType
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProductDataForProduct:_productType];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseDaysLimit
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseDaysLimit];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseExportData
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseExportMyData];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseDropbox
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseDropBox];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{    
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseDaysLimit])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForDaysLimit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseExportMyData])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForExportMyData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseDropBox])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForDropBox"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    NSString *identifierTr=productId;
    NSString *mainId=kProductIdentifier;
    NSInteger identifier=[[identifierTr substringFromIndex:[mainId length]] intValue];
    
    [GlobalFunctions updatePaymentStatus:identifier];
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
    
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"Purchase error: %d ", transaction.error.code);
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionCancelledNotification object:self userInfo:nil];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

@end
