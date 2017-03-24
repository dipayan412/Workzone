//
//  NSString+Validation.m
//  FormKit
//
//  Created by Prashant Choudhary on 9/30/12.
//  Copyright (c) 2012 Prashant Choudhary. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)
- (BOOL) validateEmail
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL testMail= [emailTest evaluateWithObject:self];
    if (testMail)
    {
        return YES;
    }
    return NO;
    
}

-(BOOL)validateMandatory
{
    if ([self length]==0)
    {
        return NO;
    }
    else return YES;
}
@end
