//
//  ServerCommunicationUser.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/30/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginV2ViewController.h"
#import "HomeViewController.h"
#import <Google/SignIn.h>

@interface ServerCommunicationUser : NSObject

+(void)insertDataToFbProfileWithResult:(id)result forViewController:(LoginV2ViewController*)viewController;
+(void)insertDataToGoogleProfileWithResult:(GIDGoogleUser *)user forViewController:(LoginV2ViewController*)viewController;
+(void)signInUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord forViewController:(LoginV2ViewController*)viewController;
+(void)skipSignInforViewController:(LoginV2ViewController*)viewController;
+(void)checkUserToken:(NSString*)userToken forViewController:(LoginV2ViewController*)viewController;
+(void)insertIntoSearchHistoryByProductId:(NSString*)productId byUserId:(NSString*)userId;
+(void)getSearchHistoyForUserId:(NSString*)userId completion:(void (^)(NSArray *))completion;
+(void)deleteSearchHistoyForUserId:(NSString*)userId;
+(void)getAllProductsFromServer;
+(NSInteger)getNumberOfProduct;
+(NSArray*)getProductArray;
+(void)getAllDiseasesFromServer;
+(NSString*)getMaxDiseaseId;
+(NSInteger)getNumberOfDisease;
+(NSArray*)getDiseaseArray;
+(void)getAllAllergensFromServer;
+(NSArray*)getAllergenArray;
+(void)getUserProductsViewController:(HomeViewController*)viewController;
+(void)updateUserProductsWithProductArray:(NSArray*)productArray DiseaseArray:(NSArray*)diseaseArray AllergenArray:(NSArray*)allergenArray AllergicProductArray:(NSArray*)allergicProductArray;
+(NSArray*)getDiseaseArrayByDiseaseIdArray:(NSArray*)diseaseIdArray;
+(NSArray*)getProductArrayByProductIdArray:(NSArray*)productIdArray;
+(NSArray*)getAllergenArrayByAllergenIdArray:(NSArray*)allergenIdArray;
+(void)newsBingSearchApiCall;
+(void)insertUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord;

@end
