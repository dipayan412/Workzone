//
//  ServerCommunicationUser.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/30/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ServerCommunicationUser.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Product.h"
#import "Disease.h"
#import "Allergens.h"
#import "ChimpKit.h"

@implementation ServerCommunicationUser

+(void)insertDataToFbProfileWithResult:(id)result forViewController:(LoginV2ViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:userSignInWithFBURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *queryDictionary;
    
    NSString *firstName = [result objectForKey:@"first_name"];
    NSString *lastName = [result objectForKey:@"last_name"];
    NSString *fbId = [result objectForKey:@"id"];
    NSString *imageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    
    if([result objectForKey:@"email"] != nil)
    {
        NSString *userName = [NSString stringWithFormat:@"%@", [result objectForKey:@"email"]];
        queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:firstName, @"FIRST_NAME", lastName, @"LAST_NAME",fbId, @"FB_ID", userName, @"USER_NAME", imageUrl, @"IMAGE_LINK", [UserDefaultsManager getDeviceToken], @"DEVICE_TOKEN", nil];
        [UserDefaultsManager setUserName:userName];
    }
    else
    {
        queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:firstName, @"FIRST_NAME", lastName, @"LAST_NAME",fbId, @"FB_ID", imageUrl, @"IMAGE_LINK", [UserDefaultsManager getDeviceToken], @"DEVICE_TOKEN", nil];
    }
    
    NSError *error;
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        if(!error)
        {
            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserFullName:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                [UserDefaultsManager saveProfilePicture:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]]]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController goToHomeViewController];
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+(void)insertDataToGoogleProfileWithResult:(GIDGoogleUser *)user forViewController:(LoginV2ViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:userSignInWithGoogleURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *queryDictionary;
    
    NSString *firstName = user.profile.givenName;
    NSString *lastName = user.profile.familyName;
    NSString *googleId = user.userID;
    NSString *imageUrl = [[user.profile imageURLWithDimension:20] absoluteString];
    NSString *userName = user.profile.email;
    queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:firstName, @"FIRST_NAME", lastName, @"LAST_NAME",googleId, @"GOOGLE_ID", userName, @"USER_NAME", imageUrl, @"IMAGE_LINK", [UserDefaultsManager getDeviceToken], @"DEVICE_TOKEN", nil];
    
    NSError *error;
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        if(!error)
        {
            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserName:userName];
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserFullName:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                [UserDefaultsManager saveProfilePicture:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]]]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController goToHomeViewController];
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+(void)signInUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord forViewController:(LoginV2ViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:signInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userName lowercaseString], @"USER_NAME", passWord, @"PASS", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        if(!error)
        {
            NSLog(@"%@", dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController goToHomeViewController];
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
            else if([[dataJSON objectForKey:@"STATUS"] intValue] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wrong Password!" message:@"Please enter your credentials again" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:dismiss];
                    
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                        return;
                    }];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+ (void)insertUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord
{
    __block BOOL success = FALSE;
    NSURL *URL = [NSURL URLWithString:insertUserURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userName lowercaseString], @"USER_NAME", passWord, @"PASS", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error)
        {
            NSLog(@"signUp %@", dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self pushViewController];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            success = false;
        }
        
    }];
    [dataTask resume];
}

+(void)skipSignInforViewController:(LoginV2ViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:skipSignInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if([[UserDefaultsManager getUDID] isEqualToString:@""])
    {
        NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        [UserDefaultsManager setUDID:uniqueIdentifier];
    }
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaultsManager getUDID], @"UDID", [UserDefaultsManager getDeviceToken], @"DEVICE_TOKEN", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        if(!error)
        {
            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                [UserDefaultsManager setUserName:@""];
                [UserDefaultsManager setUserFullName:@""];
                [UserDefaultsManager saveProfilePicture:[UIImage imageNamed:@""]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [viewController goToHomeViewController];
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Something went wrong!" message:@"Please try again!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:dismiss];
                    
                    [viewController presentViewController:alertController animated:YES completion:^{
                        
                        return;
                    }];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+(void)checkUserToken:(NSString*)userToken forViewController:(LoginV2ViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:isTokenValidURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userToken, @"TOKEN", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
        if(!error)
        {
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                if([dataJSON objectForKey:@"USER_NAME"] != [NSNull null])
                {
//                    NSLog(@"UserNameCT %@",[dataJSON objectForKey:@"USER_NAME"]);
//                    [UserDefaultsManager setUserName:[dataJSON objectForKey:@"USER_NAME"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [viewController goToHomeViewController];
                        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+(void)insertIntoSearchHistoryByProductId:(NSString*)productId byUserId:(NSString*)userId
{
    NSURL *URL = [NSURL URLWithString:insertIntoHistoryURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    //    NSLog(@"%@", [NSNumber numberWithInteger:[UserDefaultsManager getUserId]]);
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"USR_ID", productId, @"PRODUCT_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        NSLog(@"%@",dataJSON);
        if(!error)
        {
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        
    }];
    [dataTask resume];
}

+(void)getSearchHistoyForUserId:(NSString*)userId completion:(void (^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:getSearchHistory];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    //    NSLog(@"%@", [NSNumber numberWithInteger:[UserDefaultsManager getUserId]]);
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        NSLog(@"%@",dataJSON);
        if(!error)
        {
            if([[dataJSON objectForKey:@"Status"] intValue] == 1)
            {
                NSArray *arr = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"Data"]];
                completion(arr);
            }
            else
            {
                completion([[NSArray alloc] init]);
            }
        }
        else
        {
            completion([[NSArray alloc] init]);
        }
        
    }];
    [dataTask resume];
}

+(void)deleteSearchHistoyForUserId:(NSString*)userId
{
    NSURL *URL = [NSURL URLWithString:deleteHistoryURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 10;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"USR_ID", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        NSLog(@"%@",dataJSON);
        if(!error)
        {
            if([[dataJSON objectForKey:@"Status"] intValue] == 1)
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        
    }];
    [dataTask resume];
}

//+(void)getAllProductsFromServer
//{
//    NSURL *URL = [NSURL URLWithString:getAllProductsURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.timeoutInterval = 300;
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"POST"];
//    
//    NSError *error;
//    NSString *startingProductId = [self getMaxProductId];
//    NSLog(@"pid %@", startingProductId);
//    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:startingProductId, @"PRODUCT_ID", productQueryLimit, @"LIMIT", nil];
//    
//    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSDictionary *dataJSON;
//        if(data)
//        {
//            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        }
//        
//        if(!error)
//        {
//            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
//            {
//                NSError *errorCoredata = nil;
//                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//                NSManagedObjectContext *context = [appDelegate managedObjectContext];
//                
//                NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
//                
//                NSFetchRequest *request = [[NSFetchRequest alloc] init];
//                [request setEntity:chartEntity];
//                
//                NSArray *dataArray = [dataJSON objectForKey:@"DATA"];
//                for (int i = 0; i < dataArray.count; i++)
//                {
//                    NSDictionary *productObject = [dataArray objectAtIndex:i];
//                    //                    NSLog(@"err %@",productObject);
//                    Product *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
//                    
//                    product.productId = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"PRODUCT_ID"]];
//                    product.productName = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"PRODUCT_NAME"]];
//                    product.productIngredientName = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"PRODUCT_INGREDIENT_NAME"]];
//                }
//                if(![context save:&errorCoredata])
//                {
//                    NSLog(@"errr %@", errorCoredata);
//                }
//                if([[dataJSON objectForKey:@"DATA"] count] == [productQueryLimit integerValue])
//                {
//                    [self getAllProductsFromServer];
//                }
//                else
//                {
//                    [self getAllAllergensFromServer];
//                }
//            }
//            else
//            {
//                NSLog(@"prd %@",dataJSON);
//            }
//        }
//        else
//        {
//            NSLog(@"prd %@",dataJSON);
//        }
//        
//    }];
//    [dataTask resume];
//}
//
//+(NSString*)getMaxProductId
//{
//    NSError *error = nil;
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:chartEntity];
//    
//    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
//    
//    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
//    
//    if (fetchedResult && [fetchedResult count] > 0)
//    {
//        for (Product *product in fetchedResult)
//        {
//            [productIdArray addObject:[NSNumber numberWithInteger:[product.productId integerValue]]];
//        }
//    }
//    else
//    {
//        return @"1000000001";
//    }
//    int max = [[productIdArray valueForKeyPath:@"@max.intValue"] intValue];
//    max++;
//    return [NSString stringWithFormat:@"%d",max];
//}

+(void)getAllProductsFromServer
{
    NSURL *URL = [NSURL URLWithString:getAllProductsURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 300;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSString *startingProductId = [self getMaxProductId];
    NSLog(@"pid %@", startingProductId);
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:startingProductId, @"PRODUCT_ID", productQueryLimit, @"LIMIT", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        if(!error)
        {
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                NSArray *dataArray = [dataJSON objectForKey:@"DATA"];
                NSMutableArray *dataTempArray = [[NSMutableArray alloc] init];
                [dataTempArray addObjectsFromArray:[UserDefaultsManager getTempProductArray]];
                [dataTempArray addObjectsFromArray:dataArray];
                [UserDefaultsManager saveTempProductArray:dataTempArray];
                if([[dataJSON objectForKey:@"DATA"] count] == [productQueryLimit integerValue])
                {
                    [self getAllProductsFromServer];
                }
                else
                {
                    [self getAllAllergensFromServer];
                }
            }
            else
            {
                NSLog(@"prd %@",dataJSON);
            }
        }
        else
        {
            NSLog(@"prd %@",dataJSON);
        }
        
    }];
    [dataTask resume];
}
+(NSString*)getMaxProductId
{
    NSMutableArray *fetchedResult = [UserDefaultsManager getTempProductArray];
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (NSDictionary *dict in fetchedResult)
        {
            [productIdArray addObject:[NSNumber numberWithInteger:[[dict objectForKey:@"PRODUCT_ID"] integerValue]]];
        }
    }
    else
    {
        return @"1000000001";
    }
    int max = [[productIdArray valueForKeyPath:@"@max.intValue"] intValue];
    max++;
    return [NSString stringWithFormat:@"%d",max];
}

+(NSInteger)getNumberOfProduct
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return [fetchedResult count];
}

+(NSArray*)getProductArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedResult;
}

+(void)getAllDiseasesFromServer
{
    NSURL *URL = [NSURL URLWithString:getAllDiseasesURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 300;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSString *startingDiseaseId = [self getMaxDiseaseId];
    NSLog(@"did %@", startingDiseaseId);
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:startingDiseaseId, @"DISEASE_ID", productQueryLimit, @"LIMIT", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        if(!error)
        {
            //            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                NSError *errorCoredata = nil;
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                
                NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Disease" inManagedObjectContext:context];
                
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:chartEntity];
                
                NSArray *dataArray = [dataJSON objectForKey:@"DATA"];
                for (int i = 0; i < dataArray.count; i++)
                {
                    NSDictionary *productObject = [dataArray objectAtIndex:i];
                    //                    NSLog(@"err %@",productObject);
                    Disease *disease = [NSEntityDescription insertNewObjectForEntityForName:@"Disease" inManagedObjectContext:context];
                    
                    disease.diseaseId = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"DISEASE_ID"]];
                    disease.diseaseName = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"DISEASE_NAME"]];
                }
                if(![context save:&errorCoredata])
                {
                    NSLog(@"%@", errorCoredata);
                }
                if([[dataJSON objectForKey:@"DATA"] count] == [productQueryLimit integerValue])
                {
                    [self getAllDiseasesFromServer];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDiseaseDownloadComplete object:nil];
                }
            }
            else
            {
                NSLog(@"dis %@",dataJSON);
            }
        }
        else
        {
            NSLog(@"dis %@",dataJSON);
        }
        
    }];
    [dataTask resume];
}

+(NSString*)getMaxDiseaseId
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Disease" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Disease *disease in fetchedResult)
        {
            [productIdArray addObject:[NSNumber numberWithInteger:[disease.diseaseId integerValue]]];
        }
    }
    else
    {
        return @"30000001";
    }
    int max = [[productIdArray valueForKeyPath:@"@max.intValue"] intValue];
    max++;
    return [NSString stringWithFormat:@"%d",max];
}

+(NSInteger)getNumberOfDisease
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Disease" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return [fetchedResult count];
}

+(NSArray*)getDiseaseArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Disease" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedResult;
}

+(void)getAllAllergensFromServer
{
    NSURL *URL = [NSURL URLWithString:getAllAllergensUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 300;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSString *startingDiseaseId = [self getMaxAllergenId];
    NSLog(@"did %@", startingDiseaseId);
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:startingDiseaseId, @"ALLERGEN_ID", productQueryLimit, @"LIMIT", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        if(!error)
        {
            //            NSLog(@"%@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                NSError *errorCoredata = nil;
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                
                NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Allergens" inManagedObjectContext:context];
                
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:chartEntity];
                
                NSArray *dataArray = [dataJSON objectForKey:@"DATA"];
                for (int i = 0; i < dataArray.count; i++)
                {
                    NSDictionary *productObject = [dataArray objectAtIndex:i];
                    Allergens *allergen = [NSEntityDescription insertNewObjectForEntityForName:@"Allergens" inManagedObjectContext:context];
                    
                    allergen.allergenId = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"ALLERGEN_ID"]];
                    allergen.allergenName = [NSString stringWithFormat:@"%@",[productObject objectForKey:@"ALLERGEN_NAME"]];
                }
                if(![context save:&errorCoredata])
                {
                    NSLog(@"%@", errorCoredata);
                }
                if([[dataJSON objectForKey:@"DATA"] count] == [productQueryLimit integerValue])
                {
                    [self getAllAllergensFromServer];
                }
                else
                {
                    [self getAllDiseasesFromServer];
                }
            }
            else
            {
                NSLog(@"dis %@",dataJSON);
            }
        }
        else
        {
            NSLog(@"dis %@",dataJSON);
        }
        
    }];
    [dataTask resume];
}

+(NSString*)getMaxAllergenId
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Allergens" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Allergens *allergen in fetchedResult)
        {
            [productIdArray addObject:[NSNumber numberWithInteger:[allergen.allergenId integerValue]]];
        }
    }
    else
    {
        return @"700001";
    }
    int max = [[productIdArray valueForKeyPath:@"@max.intValue"] intValue];
    max++;
    return [NSString stringWithFormat:@"%d",max];
}

+(NSArray*)getAllergenArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Allergens" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedResult;
}

+(void)updateUserProductsWithProductArray:(NSArray*)productArray DiseaseArray:(NSArray*)diseaseArray AllergenArray:(NSArray*)allergenArray AllergicProductArray:(NSArray*)allergicProductArray
{
    NSURL *URL = [NSURL URLWithString:updateUserProducts];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 30;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *diseaseIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *allergenIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *allergicProductIdArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in productArray)
    {
        [productIdArray addObject:[dict objectForKey:@"PRODUCT_ID"]];
    }
    
    for(NSDictionary *dict in diseaseArray)
    {
        [diseaseIdArray addObject:[dict objectForKey:@"DISEASE_ID"]];
    }
    
    for(NSDictionary *dict in allergenArray)
    {
        [allergenIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
    }
    
    for(NSDictionary *dict in allergicProductArray)
    {
        [allergicProductIdArray addObject:[dict objectForKey:@"ENTITY_ID"]];
    }
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    [queryDictionary setObject:productIdArray forKey:@"PRODUCT_ID_LIST"];
    [queryDictionary setObject:diseaseIdArray forKey:@"DISEASE_ID_LIST"];
    [queryDictionary setObject:allergenIdArray forKey:@"ALLERGEN_ID_LIST"];
    [queryDictionary setObject:allergicProductIdArray forKey:@"ALLERGIC_PRODUCT_ID_LIST"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
        
        if(!error)
        {
            NSLog(@"updateUserProducts %@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    [dataTask resume];
}

+(void)getUserProductsViewController:(UIViewController*)viewController
{
    NSURL *URL = [NSURL URLWithString:getUserProducts];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval = 30;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:[UserDefaultsManager getUserId] forKey:@"USR_ID"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
        if(!error)
        {
            NSLog(@"getUserProducts %@",dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                NSArray *productIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"PRODUCT_LIST"]];
                NSArray *diseaseIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"DISEASE_LIST"]];
                NSArray *allergenIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"ALLERGEN_LIST"]];
                NSArray *allergicProductIdArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"ALLERGIC_PRODUCT_LIST"]];
                NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:productIdArray, @"PRODUCT_LIST", diseaseIdArray, @"DISEASE_LIST", allergenIdArray, @"ALLERGEN_LIST", allergicProductIdArray, @"ALLERGIC_PRODUCT_LIST", nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGetProfileInfoNotification object:nil userInfo:userInfo];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
                });
            }
        }
        else
        {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            });
        }
        
    }];
    [dataTask resume];
}

+(NSArray*)getDiseaseArrayByDiseaseIdArray:(NSArray*)diseaseIdArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Disease" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSMutableArray *diseaseArray = [[NSMutableArray alloc] init];
    
    for(NSString *diseaseId in diseaseIdArray)
    {
        for(Disease *disease in fetchedResult)
        {
            if([diseaseId integerValue] == [disease.diseaseId integerValue])
            {
                [diseaseArray addObject:disease];
            }
        }
    }
    return diseaseArray;
}

+(NSArray*)getProductArrayByProductIdArray:(NSArray*)productIdArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    
    for(NSString *productId in productIdArray)
    {
        for(Product *product in fetchedResult)
        {
            if([productId integerValue] == [product.productId integerValue])
            {
                [productArray addObject:product];
            }
        }
    }
    return productArray;
}

+(NSArray*)getAllergenArrayByAllergenIdArray:(NSArray*)allergenIdArray
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Allergens" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSMutableArray *allergenArray = [[NSMutableArray alloc] init];
    
    for(NSString *allergenId in allergenIdArray)
    {
        for(Allergens *allergen in fetchedResult)
        {
            if([allergenId integerValue] == [allergen.allergenId integerValue])
            {
                [allergenArray addObject:allergen];
            }
        }
    }
    return allergenArray;
}

//+(void)newsBingSearchApiCall
//{
//    NSMutableString *urlString = [[NSMutableString alloc] init];
//    [urlString appendString:bingSearchApiCall];
//    [urlString appendString:[NSString stringWithFormat:@"entities=true&"]];
//    [urlString appendString:[NSString stringWithFormat:@"q=%@&",@"FDA"]];
//    [urlString appendString:[NSString stringWithFormat:@"count=%@&",@"1000"]];
//    [urlString appendString:[NSString stringWithFormat:@"offset=%@&",@"0"]];
//    [urlString appendString:[NSString stringWithFormat:@"mkt=%@&",@"en-us"]];
//    [urlString appendString:[NSString stringWithFormat:@"safeSearch=%@",@"Moderate"]];
//    NSLog(@"bingUrl %@",urlString);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    request.timeoutInterval = 30;
//    NSLog(@"urlstr %@",urlString);
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:bingSearchApiKey1 forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSDictionary *dataJSON;
//        if(data)
//        {
//            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        }
//        else
//        {
//            
//        }
//        
//        if(!error)
//        {
//            NSArray *dataArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"value"]];
//            NSMutableArray *newsArray = [[NSMutableArray alloc] init];
//            for(NSDictionary *dict in dataArray)
//            {
//                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
//                [tmpDic setObject:[dict objectForKey:@"name"] forKey:@"name"];
//                [tmpDic setObject:[dict objectForKey:@"url"] forKey:@"url"];
//                if([[[dict objectForKey:@"image"] objectForKey:@"thumbnail"] objectForKey:@"contentUrl"])
//                {
//                    [tmpDic setObject:[[[dict objectForKey:@"image"] objectForKey:@"thumbnail"] objectForKey:@"contentUrl"] forKey:@"image"];
//                }
//                
//                [newsArray addObject:tmpDic];
//            }
//            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:newsArray, @"news", nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsDownloadCompleteNotification object:nil userInfo:userInfo];
//            });
//        }
//        else
//        {
//            NSLog(@"error %@",error);
//        }
//        
//    }];
//    [dataTask resume];
//}

+(void)newsBingSearchApiCall
{
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:getBingNews];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 30;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
//        NSLog(@"bingnNews %@", dataJSON);
        if(!error)
        {
            NSArray *dataArray = [[NSArray alloc] initWithArray:[dataJSON objectForKey:@"NEWS_LIST"]];
            NSMutableArray *newsArray = [[NSMutableArray alloc] init];
            for(NSDictionary *dict in dataArray)
            {
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                [tmpDic setObject:[dict objectForKey:@"TITLE"] forKey:@"name"];
                [tmpDic setObject:[dict objectForKey:@"URL"] forKey:@"url"];
                [tmpDic setObject:[dict objectForKey:@"IMAGE_LINK"] forKey:@"image"];
                [tmpDic setObject:@"bing" forKey:@"type"];
                
                [newsArray addObject:tmpDic];
            }
            [self relevantNewsServerCall:newsArray];
//            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:newsArray, @"news", nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsDownloadCompleteNotification object:nil userInfo:userInfo];
//            });
        }
        else
        {
            NSLog(@"error %@",error);
        }
        
    }];
    [dataTask resume];
}

+(void)relevantNewsServerCall:(NSMutableArray*)newsArray
{
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:relevantNews];
    [urlString appendString:[NSString stringWithFormat:@"?uId=%@",[UserDefaultsManager getUserId]]];
    NSLog(@"relevantNewsUrl %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 30;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSArray *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
//        NSLog(@"relevantNews %@", [dataJSON firstObject]);
        if(!error)
        {
            NSArray *dataArray = [[NSArray alloc] initWithArray:[dataJSON firstObject]];
            for(NSDictionary *dict in dataArray)
            {
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                [tmpDic setObject:[[[dict objectForKey:@"TITLE"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] forKey:@"name"];
                [tmpDic setObject:[dict objectForKey:@"NEWS_URL"] forKey:@"url"];
                [tmpDic setObject:[dict objectForKey:@"NEWS_IMAGE_URL"] forKey:@"image"];
                
                [newsArray addObject:tmpDic];
            }
            for (int i = 0; i < newsArray.count; i++)
            {
                int randomInt1 = arc4random() % [newsArray count];
                int randomInt2 = arc4random() % [newsArray count];
                [newsArray exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
            }
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:newsArray, @"news", nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewsDownloadCompleteNotification object:nil userInfo:userInfo];
            });
        }
        else
        {
            NSLog(@"error %@",error);
        }
        
    }];
    [dataTask resume];
}

+(void)signInUserWithUserName:(NSString*)userName andPassWord:(NSString*)passWord
{
    NSURL *URL = [NSURL URLWithString:relevantNews];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userName lowercaseString], @"USER_NAME", passWord, @"PASS", nil];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: queryDictionary, @"Queries",nil];
    NSLog(@"%@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        else
        {
            
        }
        if(!error)
        {
            NSLog(@"%@", dataJSON);
            if([[dataJSON objectForKey:@"STATUS"] intValue] == 1)
            {
                [UserDefaultsManager setUserToken:[dataJSON objectForKey:@"TOKEN"]];
                [UserDefaultsManager setUserId:[dataJSON objectForKey:@"USR_ID"]];
                
            }
            else if([[dataJSON objectForKey:@"STATUS"] intValue] == 0)
            {
                
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
    [dataTask resume];
}

@end
