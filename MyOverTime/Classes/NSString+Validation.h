//
//  NSString+Validation.h
//  FormKit
//
//  Created by Prashant Choudhary on 9/30/12.
//  Copyright (c) 2012 Prashant Choudhary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)
- (BOOL) validateEmail ;
-(BOOL)validateMandatory;
@end
