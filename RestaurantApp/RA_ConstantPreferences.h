//
//  RA_ConstantPreferences.h
//  RestaurantApp
//
//  Created by World on 2/13/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>


// Amazon Keys and ARN
#define ACCESS_KEY_ID                   @"AKIAITY4LPQVJK5IZWZA"
#define SECRET_KEY                      @"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"
#define PLATFORM_APPLICATION_ARN        @"arn:aws:sns:us-east-1:457637732854:app/APNS_SANDBOX/Restaurant_Sandbox"

// Server access key and Api

#define AccessKey @"12345"
#define AdminPageURL @"http://algonyx.com/"

#define galleryAPI @"http://algonyx.com/restaurant/api/get-all-gallery-photos.php"
#define CategoryAPI @"http://algonyx.com/restaurant/api/get-all-category-data.php"
#define MenuAPI @"http://algonyx.com/restaurant/api/get-menu-data-by-category-id.php"
#define TaxCurrencyAPI @"http://algonyx.com/restaurant/api/get-tax-and-currency.php"
#define MenuDetailAPI @"http://algonyx.com/restaurant/api/get-menu-detail.php"
#define SendReservationAPI @"http://algonyx.com/restaurant/api/add-reservation.php"
#define SendTakeAwayAPI @"http://algonyx.com/restaurant/api/add-take-away.php"
#define MenuSharingAPI @"http://algonyx.com/restaurant/menu-sharing.php"

// NewsFeed Api
#define NewsFeedAPI @"http://feeds.feedburner.com/MobileTuts?format=xml"

// Google maps Api key
#define GoogleMapAPIKey @"AIzaSyAVvY8n1Hy3gn3Npf25JoNER9-h4BPaGY4"

// About US page info
#define kLatitude        @"-6.208992"
#define kLongitude       @"106.844775"
#define restaurant_name  @"The Restaurant"
#define kAddress         @"Sudirman Street No. 12, West Jakarta 13930"
#define kPhone           @"12344455"
#define kEmail           @"reservation@restaurant.com"

// Localized title Keys
#define kHome @"kHome"
#define kMenu @"kMenu"
#define kReservation @"kReservation"
#define kFindUs @"kFindUs"
#define kRestaurantTitle @"The Fusion Restaurant"

#define kMenuTitle @"kMenuTitle"
#define kFindUsTitle @"kFindUsTitle"
#define kReservationTitle @"kReservationTitle"


//color constants
#define kPageBGColor            [UIColor colorWithRed:242.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0]
#define kNavigationBarColor     [UIColor colorWithRed:211.0f/255.0f green:162.0f/255.0f blue:115.0f/255.0f alpha:1.0f]
#define kTabBarColor            [UIColor colorWithRed:212.0f / 255.0f green:162.0f / 255.0f blue:112.0f / 255.0f alpha:1.0f]
#define kBorderColor            [UIColor colorWithRed:220.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1.0f].CGColor
#define kCellTitleColor         [UIColor colorWithRed:156.0f/255.0f green:142.0f/255.0f blue:142.0f/255.0f alpha:1.0f]
#define kSettingsPageCommonColor [UIColor colorWithRed:138.0f/255.0f green:123.0f/255.0f blue:123.0f/255.0f alpha:1.0f]
#define kSearchViewBGColor      [UIColor colorWithRed:212.0f / 255.0f green:162.0f/255.0f blue:112.0f / 255.0f alpha:1.0f]
#define kTextItemCellPriceLabelTextColor [UIColor colorWithRed:184.0f/255.0f green:178.0f/255.0f blue:177.0f/255.0f alpha:1.0f]
#define kButtonTopColorForGradient  [UIColor colorWithRed:209.0f/255.0f green:70.0f/255.0f blue:18.0f/255.0f alpha:1.0f]
#define kButtonDownColorForGradient [UIColor colorWithRed:167.0f/255.0f green:30.0f/255.0f blue:13.0f/255.0f alpha:1.0f]


//Image Constants
#define kHomeButtonSelected     [UIImage imageNamed:@"tabbar-addnew-selected.png"]
#define kHomeButtonDeselected   [UIImage imageNamed:@"tabbar-addnew.png"]

#define kReservationButtonSelected [UIImage imageNamed:@"tabbar-elements-selected.png"]
#define kReservationButtonDeselected [UIImage imageNamed:@"tabbar-elements.png"]

#define kMenuButtonSelected     [UIImage imageNamed:@"tabbar-recipe-selected.png"]
#define kMenuButtonDeselected   [UIImage imageNamed:@"tabbar-recipe.png"]

#define kFindUsButtonSelected   [UIImage imageNamed:@"tabbar-wine-selected.png"]
#define kFindUsButtonDeselected [UIImage imageNamed:@"tabbar-wine.png"]

#define kTabBarBackgroundImageiPhone    [UIImage imageNamed:@"tabbar-bg.png"]
#define kTabBarBackgroundImageiPadRetina    [UIImage imageNamed:@"tabbar-bg~ipad@2x.png"]
#define kTabBarBackgroundImageiPad  [UIImage imageNamed:@"tabbar-bg~ipad.png"]

#define kPlusButtonIPhone       [UIImage imageNamed:@"plus.png"]
#define kplusButtonIPadRetina   [UIImage imageNamed:@"plus~ipad@2x.png"]
#define kPlusButtonIPad         [UIImage imageNamed:@"plus~ipad.png"]

#define kMinusButtonIPhone            [UIImage imageNamed:@"minus.png"]
#define kMinusButtonIPadRetina        [UIImage imageNamed:@"minus~ipad@2x.png"]
#define kMinusButtonIPad              [UIImage imageNamed:@"minus~ipad.png"]

#define kCellIndicator [UIImage imageNamed:@"categoryview-cell-indicator.png"]
#define kCellSeparator [UIImage imageNamed:@"categoryview-cell-separator.png"]

#define kCheckBoxSelected [UIImage imageNamed:@"checkBoxSelected.png"]
#define kCheckBoxDeselcted [UIImage imageNamed:@"checkBoxDeselected.png"]

#define kSearchIconImage [UIImage imageNamed:@"searchIcon.png"]
#define kReloadButtonImage [UIImage imageNamed:@"reloadButton.png"]

#define kRestaurantSlide1   @"cover_slide1.jpg"
#define kRestaurantSlide2   @"cover_slide2.png"
#define kRestaurantSlide3   @"cover_slide3.png"
#define kRestaurantSlide4   @"cover_slide4.png"

#define kSettingsButton     [UIImage imageNamed:@"settings.png"]
#define kCallButton         [UIImage imageNamed:@"callButton.png"]

#define kRestaurantCellImage    [UIImage imageNamed:@"cell1.png"]
#define kGalleryCellImage       [UIImage imageNamed:@"cell2.png"]
#define kNewsCellImage          [UIImage imageNamed:@"cell3.png"]

@interface RA_ConstantPreferences : NSObject

@end
