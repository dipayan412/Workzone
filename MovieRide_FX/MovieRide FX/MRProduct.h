//
//  MRProduct.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/18.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRProduct : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *poster;
@property (nonatomic) NSString *previewClip;
@property (nonatomic) NSString *templateFolder;
@property (nonatomic) NSString *productId;

+(NSArray *)productsFromFile:(NSString *)productsFile;
+(MRProduct *)productWithIdentifeir:(NSString *)productId fromFile:(NSString *)productsFile;

@end
