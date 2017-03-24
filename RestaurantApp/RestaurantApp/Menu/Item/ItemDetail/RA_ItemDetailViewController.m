//
//  RA_ItemDetailViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ItemDetailViewController.h"
#import "RA_ImageCache.h"
#import "RA_AppDelegate.h"
#import "RA_ShareManager.h"

@interface RA_ItemDetailViewController ()
{
    RA_ImageCache *imgCh;
    
    BOOL shareForBoth;
    BOOL shareForTwitter;
    BOOL shareForFacebook;
}

@end

@implementation RA_ItemDetailViewController

@synthesize itemImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMenuObject:(RA_MenuObject*)_object
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        menuObject = [[RA_MenuObject alloc] init];
        menuObject = _object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgCh = [[RA_ImageCache alloc] init];
    
    //setting backgroung color of the page,title color and title text
    self.view.backgroundColor = kPageBGColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = menuObject.menuName;
    
    //modifying the view elements
    
    itemImageViewBGView.backgroundColor = backGroundBorderForDetailsView.backgroundColor = [UIColor clearColor];
    backGroundBorderForTabView.backgroundColor = tabView.backgroundColor = detailsView.backgroundColor = [UIColor whiteColor];
    
    backGroundBorderForDetailsView.layer.cornerRadius = detailsView.layer.cornerRadius = 2.0f;
    backGroundBorderForDetailsView.layer.borderColor = kBorderColor;
    backGroundBorderForDetailsView.layer.borderWidth = 4.0f;
    
    backGroundBorderForTabView.layer.cornerRadius = tabView.layer.cornerRadius = 2.0f;
    backGroundBorderForTabView.layer.borderColor = kBorderColor;
    backGroundBorderForTabView.layer.borderWidth = 4.0f;
    
    orderButton.layer.borderWidth = 1.0f;
    orderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    orderButton.layer.borderColor = kSettingsPageCommonColor.CGColor;
    [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    
    takeOrderInAlertView = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kNumberOfPeople", nil) message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    takeOrderInAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[takeOrderInAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self fetchData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //show busy screen
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = AMLocalizedString(@"kWait", nil);
    hud.labelColor = [UIColor lightGrayColor];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    [orderButton setTitle:AMLocalizedString(@"kOrder", nil) forState:UIControlStateNormal];
    descriptioTitleLabel.text = AMLocalizedString(@"kDescription", nil);
    
    if([UIScreen mainScreen].bounds.size.height > 568)//arranging view for ipad
    {
        CGRect frameImage = itemImageView.frame;
        frameImage.size.height = 400;
        itemImageView.frame = frameImage;
        
        CGRect frameImageBG = itemImageViewBGView.frame;
        frameImageBG.size.height = 410;
        itemImageViewBGView.frame = frameImageBG;
        
        CGRect frameTabView = tabView.frame;
        frameTabView.origin.y = 500;
        frameTabView.origin.x = 20;
        tabView.frame = frameTabView;
        
        CGRect frameTabViewBG = backGroundBorderForTabView.frame;
        frameTabViewBG.origin.x = 19;
        frameTabViewBG.origin.y = 499;
        backGroundBorderForTabView.frame = frameTabViewBG;
        
        descriptioTitleLabel.frame = frameTabView;
        
        CGRect frameDetailsView = detailsView.frame;
        frameDetailsView.origin.y = frameTabView.origin.y + frameTabView.size.height;
        frameDetailsView.origin.x = 20;
        frameDetailsView.size.width = self.view.frame.size.width - 40;
        detailsView.frame = frameDetailsView;
        
        CGRect frameDetailsViewBG = backGroundBorderForDetailsView.frame;
        frameDetailsViewBG.origin.x = 19;
        frameDetailsViewBG.origin.y = frameDetailsView.origin.y - 1;
        frameDetailsViewBG.size.width = self.view.frame.size.width - 38;
        backGroundBorderForDetailsView.frame = frameDetailsViewBG;
        
        CGRect frameItemName = itemNameLabel.frame;
        frameItemName.origin.y = frameDetailsView.origin.y + 2;
        frameItemName.origin.x = frameDetailsView.origin.x + 10;
        itemNameLabel.frame = frameItemName;
        
        CGRect frameOrderBtn = orderButton.frame;
        frameOrderBtn.origin.x = self.view.frame.size.width - frameOrderBtn.size.width - 60;
        orderButton.frame = frameOrderBtn;
        
        CGRect framePiceLabel = itemPriceLabel.frame;
        framePiceLabel.origin.x = 10;
        itemPriceLabel.frame = framePiceLabel;
        
        CGRect frameDescriptionTextView = itemDescriptionTextView.frame;
        frameDescriptionTextView.origin.x = 0;
        frameDescriptionTextView.size.width = self.view.frame.size.width - 50;
        itemDescriptionTextView.frame = frameDescriptionTextView;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //hide busy screen when the view disappears
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [super viewWillDisappear:animated];
}


/**
 * Method name: fetchData
 * Description: request to server for menu object
 * Parameters: none
 */

-(void)fetchData
{
    //create request for the details of the selected menu object
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@?accesskey=%@&menu_id=%@", MenuDetailAPI,AccessKey, menuObject.menuId];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //request succeeded
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    if (error)
    {
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    [orderButton setTitle:AMLocalizedString(@"kOrder", nil) forState:UIControlStateNormal];
    
    NSArray *responseArray = [responseObject objectForKey:@"data"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){//create a different thread
        for(int i = 0; i < responseArray.count; i++)
        {
            NSDictionary *dic = [[responseArray objectAtIndex:i] objectForKey:@"Menu_detail"];
            
            //fill up the description and serveFor field for the selected menu object
            menuObject.menuDetails = [dic objectForKey:@"Description"];
            menuObject.menuServeFor = [dic objectForKey:@"Serve_for"];
            
            //fill up the view with the data received from the server
            itemDescriptionTextView.text = menuObject.menuDetails;
            
            NSMutableString *urlStr = [[NSMutableString alloc] init];
            [urlStr appendFormat:@"%@restaurant/%@",AdminPageURL,[dic objectForKey:@"Menu_image"]];
            [self adjustImageViewToImage:[imgCh getImage:urlStr]];
            
            itemNameLabel.text = menuObject.menuName;
            RA_AppDelegate *apdl = (RA_AppDelegate*)[[UIApplication sharedApplication] delegate];
            itemPriceLabel.text = [NSString stringWithFormat:@"%@: %@ %@ \n%@: %@",AMLocalizedString(@"kPrice", nil),menuObject.menuPrice,apdl.currency,AMLocalizedString(@"kServe", nil),menuObject.menuServeFor];
            
            UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonAction)];
            self.navigationItem.rightBarButtonItem = shareButtonItem;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    //request failed. Could not connect to server
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kConnectServer", nil) delegate:Nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles: nil];
    [alert show];
}

/**
 * Method name: shareButtonAction
 * Description: share action
 * Parameters: none
 */

-(void)shareButtonAction
{
    if(![RA_UserDefaultsManager isFacebookConnected] && ![RA_UserDefaultsManager isTwitterConnected])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Facebook and Twitter are not enabled for this app. Please go to settings and enable share platform." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if([RA_UserDefaultsManager isFacebookConnected] && [RA_UserDefaultsManager isTwitterConnected])
        {
            shareForFacebook =
            shareForTwitter = NO;
            shareForBoth = YES;
            UIActionSheet * shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share To" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter",nil];
            
            [shareActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else if ([RA_UserDefaultsManager isTwitterConnected])
        {
            shareForBoth =
            shareForFacebook = NO;
            shareForTwitter = YES;
            UIActionSheet * shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share To" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter",nil];
            
            [shareActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else
        {
            shareForBoth =
            shareForTwitter = NO;
            shareForFacebook = YES;
            UIActionSheet * shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share To" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",nil];
            
            [shareActionSheet showFromTabBar:self.tabBarController.tabBar];
        }
    }
}

#pragma mark UIActionSheet delegate methods

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(shareForBoth)
    {
        switch (buttonIndex)
        {
            case 0:
                
                [RA_ShareManager shareToPlatfrom:kFacebook object:menuObject menuImage:itemImageView.image fromController:self];
                
                break;
                
            case 1:
                
                [RA_ShareManager shareToPlatfrom:kTwitter object:menuObject menuImage:itemImageView.image fromController:self];
                
                break;
                
            default:
                break;
        }
    }
    else if (shareForFacebook)
    {
        switch (buttonIndex)
        {
            case 0:
                
                [RA_ShareManager shareToPlatfrom:kFacebook object:menuObject menuImage:itemImageView.image fromController:self];
                
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex)
        {
            case 0:
                
                [RA_ShareManager shareToPlatfrom:kTwitter object:menuObject menuImage:itemImageView.image fromController:self];
                
                break;
                
            default:
                break;
        }
    }
}

/**
 * Method name: adjustImageViewToImage
 * Description: fit to aspect ration
 * Parameters: image of the item
 */

-(void)adjustImageViewToImage:(UIImage*)image
{
    //adjust the image size of the item, maintaing aspectfit
    itemImageView.image = image;
    
    float ratio = image.size.width / image.size.height;
    int widthOfImageViewShouldBe = ratio * itemImageView.frame.size.height;
    int xShouldBe = self.view.frame.size.width/2 - (widthOfImageViewShouldBe / 2);
    
    CGRect imageFrame = itemImageView.frame;
    imageFrame.origin.x = xShouldBe;
    imageFrame.size.width = widthOfImageViewShouldBe;
    itemImageView.frame = imageFrame;
    
    CGRect bgFrame = itemImageViewBGView.frame;
    bgFrame.origin.x = itemImageView.frame.origin.x - 5;
    bgFrame.size.width = itemImageView.frame.size.width + 10;
    itemImageViewBGView.frame = bgFrame;
    
    itemImageViewBGView.backgroundColor = backGroundBorderForDetailsView.backgroundColor = [UIColor whiteColor];
    itemImageViewBGView.layer.cornerRadius = 2.0f;
    itemImageViewBGView.layer.borderColor = kBorderColor;
    itemImageViewBGView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Method name: orderButtonAction
 * Description: pop up an alertview for the input of number of people
 * Parameters: order button
 */

-(IBAction)orderButtonAction:(UIButton*)sender
{
    [takeOrderInAlertView show];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert == takeOrderInAlertView)
    {
        NSString *number = [takeOrderInAlertView textFieldAtIndex:0].text;
        
        if (buttonIndex == 1)
        {
            if(number == nil || [number isEqualToString:@""])
            {
                LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kEnterOrder", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            //menu objects those are ordered are listed
            
            menuObject.numberOfOrder = number.intValue;
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[RA_UserDefaultsManager getOrderItemsArray]];
            if(items)
            {
                int index = -1;
                for(int i=0; i<items.count; i++)
                {
                    RA_MenuObject *object = [items objectAtIndex:i];
                    if([object.menuId isEqualToString:menuObject.menuId])
                    {
                        index = i;
                        break;
                    }
                }
                if(index >= 0)
                {
                    [items replaceObjectAtIndex:index withObject:menuObject];
                }
                else
                {
                    [items addObject:menuObject];
                }
            }
            else
            {
                items = [[NSMutableArray alloc] init];
                [items addObject:menuObject];
            }
            
            [RA_UserDefaultsManager addMenuItems:items];
        }
    }
}

@end
