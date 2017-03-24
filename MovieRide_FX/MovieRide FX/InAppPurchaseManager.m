//
//  InAppPurchaseManager.m
//  ZepniPravopis
//
//  Created by Nazmul Quader on 3/31/12.
//  Copyright (c) 2012 Algonyx. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "MRAppDelegate.h"

@implementation InAppPurchaseManager

static InAppPurchaseManager *instance;

@synthesize productInitializationDone;
@synthesize productDetailsDelegate;
@synthesize progressImageMaxFrame;
@synthesize progressLabel;
@synthesize progressImageView;

+(InAppPurchaseManager*)getInstance
{
    if (instance == nil)
    {
        instance = [[InAppPurchaseManager alloc] init];
    }
    
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {   
        loadingView = [[MRAlertView alloc] init];
        
        // Add some custom content to the alert view
        
        [loadingView setContainerView:[self createProgreesViewToShowInAlert]];
        [loadingView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
        [loadingView setUseMotionEffects:true];
        [self showProgress:0.0f];
    }
    return self;
}

-(void)getProductDetailsForProduct:(MRProduct *)product
{
    NSLog(@"Requestion product info for %@", product.productId);
    
    NSSet *productIdentifiers = [NSSet setWithObject:product.productId];
    
    /*
    switch (_product)
    {
        case ProductTypeMRacer:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseMRacesProductId, nil];
            
            break;
            
        case ProductTypeSpaceWalk2:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseSpaceWalk2ProductId, nil];
            
            break;
            
        case ProductTypeSpaceWars:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseSpaceWars1ProductId, nil];
            
            break;
            
        case ProductTypeTransPodGiant:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseTranspodGiantProductId, nil];
            
            break;
            
        default:
            break;
    }
     */
    
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *productReq = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        
        productReq.delegate = self;
        [productReq start];
        
        productInitializationDone = NO;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Purchase" message:@"Purchases are not currently allowed for your account." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)requestProductDataForProduct:(MRProduct *)product
{
    /*
    NSSet *productIdentifiers;
    switch (_product)
    {
        case ProductTypeMRacer:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseMRacesProductId, nil];
            
            break;
            
        case ProductTypeSpaceWalk2:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseSpaceWalk2ProductId, nil];
            
            break;
            
        case ProductTypeSpaceWars:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseSpaceWars1ProductId, nil];
            
            break;
            
        case ProductTypeTransPodGiant:
            
            productIdentifiers = [NSSet setWithObjects:kInAppPurchaseTranspodGiantProductId, nil];
            
            break;
            
        default:
            break;
    }
     */
    
    NSSet *productIdentifiers = [NSSet setWithObject:product.productId];
    
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
        NSArray *products = response.products;
        validProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
        if (validProduct)
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setLocale:[validProduct priceLocale]];
            NSString *str = [formatter stringFromNumber:[validProduct price]];
            if(productDetailsDelegate)
            {
                [productDetailsDelegate localizedProductPrice:str];
            }
        }
        else
        {
            NSLog(@"No products available");
            if(productDetailsDelegate)
            {
                [productDetailsDelegate localizedProductPrice:@""];
            }
        }
    }
    else
    {
        NSArray *products = response.products;
        proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
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
        //[productsRequest release];
        
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
    
    /*
    if ([purchasedItemIDs containsObject:kInAppPurchaseMRacesProductId])
    {
        
    }
    else if ([purchasedItemIDs containsObject:kInAppPurchaseSpaceWalk2ProductId])
    {
        
    }
    else if ([purchasedItemIDs containsObject:kInAppPurchaseSpaceWars1ProductId])
    {
        
    }
    else if ([purchasedItemIDs containsObject:kInAppPurchaseTranspodGiantProductId])
    {
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerInvalidRestoreNotification object:self userInfo:nil];
    }
     */
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
- (void)loadStoreForPruduct:(MRProduct *)product
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProductDataForProduct:product];
    //[self getProductDetailsForProduct:product];
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

/*
- (void)purchaseSpaceWalk2
{
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseSpaceWars1
{
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseMRacer
{
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseTranspodGiant
{
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
*/

- (void)purchaseTemplate
{
    SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    /*
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseMRacesProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForMRacer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseSpaceWalk2ProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForSpaceWalk2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseSpaceWars1ProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptSpaceWars1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseTranspodGiantProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceiptForTransPodGiant"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     */
    
    // save the transaction receipt to disk
    NSString *key = [NSString stringWithFormat:@"receipt_%@", transaction.payment.productIdentifier];
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//
// enable pro features
//
- (void)provideContent:(MRProduct *)product
{
    NSLog(@"provideContent %@", product.productId);
    //[MRUtil productPurchased:[self getFolderNameForProduct:productId]];
    [MRUtil productPurchased:product.templateFolder];
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    NSLog(@"FinishTransaction %@", transaction.payment.productIdentifier);
    
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
    NSLog(@"statePurchased %@", transaction.payment.productIdentifier);
    
    if(transaction.downloads)
    {
        [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
        [loadingView show];
    }
    else
    {
        [self recordTransaction:transaction.originalTransaction];
        
        //[self provideContent:transaction.originalTransaction.payment.productIdentifier];
        NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
        NSString *productId = transaction.originalTransaction.payment.productIdentifier;
        MRProduct *product = [MRProduct productWithIdentifeir:productId fromFile:productsFile];
        [self provideContent:product];
        
        [self finishTransaction:transaction wasSuccessful:YES];
    }
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"RestoreTransaction %@", transaction.payment.productIdentifier);
    if(transaction.downloads)
    {
        [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
        [loadingView show];
    }
    else
    {
        [self recordTransaction:transaction.originalTransaction];
        
        //[self provideContent:transaction.originalTransaction.payment.productIdentifier];
        NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
        NSString *productId = transaction.originalTransaction.payment.productIdentifier;
        MRProduct *product = [MRProduct productWithIdentifeir:productId fromFile:productsFile];
        [self provideContent:product];
        
        [self finishTransaction:transaction wasSuccessful:YES];
    }
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"downloads count %d", downloads.count);
    if(downloads.count > 0)
    {
        SKDownload *item = [downloads objectAtIndex:0];
//        item.contentIdentifier
        if(item.downloadState == SKDownloadStateWaiting)
        {
            NSLog(@"waiting to download");
        }
        else if (item.downloadState == SKDownloadStateActive)
        {
            float progress = item.progress;
            NSLog(@"active download %0.2f", progress);
            [self showProgress:progress];
        }
        else if (item.downloadState == SKDownloadStateFinished)
        {
            float progress = item.progress;
            [self showProgress:progress];
            
            [loadingView closeAlert];
            NSLog(@"download finished %@", item.contentURL);
            for (SKPaymentTransaction *transaction in queue.transactions)
            {
                if ([transaction.payment.productIdentifier isEqualToString:item.contentIdentifier])
                {
                    [self processDownload:item];
                    
                    [self recordTransaction:transaction];
                    //[self provideContent:transaction.payment.productIdentifier];
                    
                    NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
                    NSString *productId = transaction.payment.productIdentifier;
                    MRProduct *product = [MRProduct productWithIdentifeir:productId fromFile:productsFile];
                    [self provideContent:product];
                    
                    [self finishTransaction:transaction wasSuccessful:YES];
                }
            }
        }
        else if (item.downloadState == SKDownloadStateFailed)
        {
            [loadingView closeAlert];
            NSLog(@"download failed");
            for (SKPaymentTransaction *transaction in queue.transactions)
            {
                if ([transaction.payment.productIdentifier isEqualToString:item.contentIdentifier])
                {
                   [self failedTransaction:transaction];
                }
            }
        }
        else if (item.downloadState == SKDownloadStateCancelled)
        {
            [loadingView closeAlert];
            NSLog(@"download cancelled");
            for (SKPaymentTransaction *transaction in queue.transactions)
            {
                if ([transaction.payment.productIdentifier isEqualToString:item.contentIdentifier])
                {
                    [self failedTransaction:transaction];
                }
            }
        }
    }
}

/*
-(NSString*)getFolderNameForProduct:(NSString*)_productId
{
    if([_productId isEqualToString:kInAppPurchaseMRacesProductId])
    {
        return mrMRacer;
    }
    else if([_productId isEqualToString:kInAppPurchaseSpaceWalk2ProductId])
    {
        return mrSpacewalk2;
    }
    else if([_productId isEqualToString:kInAppPurchaseSpaceWars1ProductId])
    {
        return mrSpacewars1;
    }
    else if([_productId isEqualToString:kInAppPurchaseTranspodGiantProductId])
    {
        return mrTranspod2;
    }
    return @"";
}
 */

- (void) processDownload:(SKDownload*)download;
{
    // convert url to string, suitable for NSFileManager
    NSString *path = [download.contentURL path];
    
    // files are in Contents directory
    path = [path stringByAppendingPathComponent:@"Contents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSString *dir = [MRUtil downloadableContentPath]; // not written yet
    
    for (NSString *file in files)
    {
        NSString *fullPathSrc = [path stringByAppendingPathComponent:file];
        NSString *fullPathDst = [dir stringByAppendingPathComponent:file];
        
        // not allowed to overwrite files - remove destination file
        [fileManager removeItemAtPath:fullPathDst error:NULL];
        
        if ([fileManager moveItemAtPath:fullPathSrc toPath:fullPathDst error:&error] == NO) {
            NSLog(@"Error: unable to move item: %@", error);
        }
    }
    
    // NOT SHOWN: use download.contentIdentifier to tell your model that we've been downloaded
}

-(void)showProgress:(CGFloat)progress {
    
    //must update GUI on main thread

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        double newWidth = self.progressImageMaxFrame.size.width * progress;
        CGRect newFrame = self.progressImageMaxFrame;
        newFrame.size.width = newWidth;
        
        [UIView animateWithDuration:0.4 animations:^{
            NSString *st = @"%";
            int progressVal = progress * 100;
            self.progressLabel.text = [NSString stringWithFormat:@"%d%@", progressVal, st];
            [self.progressImageView setFrame:newFrame];
        }];
        
    }];
}

-(UIView*)createProgreesViewToShowInAlert
{
    UIView *alertDemoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 100)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Downloading Clip...";
    [alertDemoView addSubview:titleLabel];
    
    if(!progressImageView)
    {
        self.progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 200, 14)];
        self.progressImageView.image = [UIImage imageNamed:@"4_processing_bar.png"];
        self.progressImageView.contentMode = UIViewContentModeScaleToFill;
        self.progressImageMaxFrame = progressImageView.frame;
        [alertDemoView addSubview:self.progressImageView];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
        self.progressLabel.text = @"0%";
        self.progressLabel.font = [UIFont systemFontOfSize:12];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        [alertDemoView addSubview:self.progressLabel];
    }
    
    return alertDemoView;
}

@end
