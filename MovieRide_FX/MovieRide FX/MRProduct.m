//
//  MRProduct.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/18.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRProduct.h"
#import "MRUtil.h"
#import "RXMLElement.h"

@implementation MRProduct

+(NSArray *)productsFromFile:(NSString *)productsFile {
    
    NSMutableArray *products = [NSMutableArray array];
    
    NSError *error;
    NSString *xmlStr = [NSString stringWithContentsOfFile:productsFile encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.description);
        [MRUtil showErrorMessage:@"Could not load the template."];
    }
    
    NSLog(@"Parsing products from XML");
    
    RXMLElement *productsEl = [RXMLElement elementFromXMLString:xmlStr encoding:NSUTF8StringEncoding];
    NSArray *productArr = [productsEl children:@"Product"];
    for (RXMLElement *productEl in productArr) {
        MRProduct *product = [[MRProduct alloc] init];
        
        product.name = [productEl child:@"Name"].text;
        product.type = [productEl child:@"Type"].text;
        product.poster = [productEl child:@"Poster"].text;
        product.previewClip = [productEl child:@"PreviewClip"].text;
        product.templateFolder = [productEl child:@"TemplateFolder"].text;
        product.productId = [productEl child:@"ProductId"].text;
        
        [products addObject:product];
    }
    
    return [products copy];
}

+(MRProduct *)productWithIdentifeir:(NSString *)productId fromFile:(NSString *)productsFile {
    MRProduct *foundProduct = nil;
    
    NSArray *products = [MRProduct productsFromFile:productsFile];
    for (MRProduct *product in products) {
        if ([product.productId isEqualToString:productId]) {
            foundProduct = product;
            break;
        }
    }
    
    return foundProduct;
}

@end
