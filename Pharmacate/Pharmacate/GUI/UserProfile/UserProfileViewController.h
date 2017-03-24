//
//  UserProfileViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property(nonatomic, strong) NSArray *selectedProductsArray;
@property(nonatomic, strong) NSArray *selectedDiseasesArray;
@property(nonatomic, strong) NSArray *selectedAllergenArray;
@property(nonatomic, strong) NSArray *selectedAllergicProductArray;
@property(nonatomic, strong) NSString *selectedProfileSection;

@end
