

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "SubscriptionDetailController.h"

#define kTitle 1
#define  kSubTitle 2
#define kSwitch 3
//@protocol SubscriptionViewControllerDelegate ;
@interface SubscriptionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    int adjustFirstTwoSubscription;
    
    UIAlertView *loadingView;
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath * lastIndexPath;
@property (nonatomic,retain) 	NSArray *list,*description;
@property (nonatomic) 			NSInteger firstSelected,secondSelected;
@property (nonatomic,retain) InAppPurchaseManager *purchaseManager;

@end

