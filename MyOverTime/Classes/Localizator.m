//
//  Localizator.m
//  MyOvertime
//
//  Created by Kostia on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Localizator.h"



@implementation Localizator

//==============================================================================
+ ( NSStringEncoding ) encodingForActiveLanguage
{
    NSStringEncoding activeEncoding = NSUTF8StringEncoding;
    NSArray * langs = [ NSLocale preferredLanguages ];
    
    //    //NSLog( @"preferred locales = %@", langs );
    
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    
    if( lang )
    {
        if( [ lang isEqualToString: @"en" ] )               // English      (!)
        {
            activeEncoding = NSUTF8StringEncoding;
        }
        else if( [ lang isEqualToString: @"de" ] )          // German       (!)
        {
            activeEncoding = NSWindowsCP1252StringEncoding;
        }
        else if( [ lang isEqualToString: @"es" ] )          // Spanish      (!)
        {
            activeEncoding = NSISOLatin1StringEncoding;
        }
        else if( [ lang isEqualToString: @"fr" ] )          // French       (!)
        {
            activeEncoding = NSWindowsCP1252StringEncoding;
        }
        else if( [ lang isEqualToString: @"it" ] )          // Italian      (!)
        {
            activeEncoding = NSWindowsCP1252StringEncoding;
        }
        else if( [ lang isEqualToString: @"ja" ] )          // Japanese
        {
            activeEncoding = NSISO2022JPStringEncoding;
            //activeEncoding = NSUTF8StringEncoding;
        }
        else if( [ lang isEqualToString: @"ko" ] )          // Korean
        {
            activeEncoding = NSUTF8StringEncoding;
        }
        else if( [ lang isEqualToString: @"nl" ] )          // Dutch        (!)
        {
            activeEncoding = NSUTF8StringEncoding;
        }
        else if( [ lang isEqualToString: @"pt" ] )          // Portuguese   (!)
        {
            activeEncoding = NSISOLatin1StringEncoding;
        }
        else if( [ lang isEqualToString: @"ru" ] )          // Russian
        {
            activeEncoding = NSWindowsCP1251StringEncoding;
        }
        else if( [ lang isEqualToString: @"uk" ] )          // Ukrainian
        {
            activeEncoding = NSWindowsCP1251StringEncoding;
        }
        else if( [ lang isEqualToString: @"zh-Hans" ] )     // Chinese
        {
            activeEncoding = NSUTF8StringEncoding;
        }
    }
    
    return activeEncoding;
}


//==============================================================================
+ ( NSData * ) encodedDataFromString: ( NSString * ) string
{
    return
    [ Localizator encodedDataFromString: string
                           withEncoding: -1
     ];
}


//==============================================================================
+ ( NSData * ) encodedDataFromString: ( NSString * ) string
                        withEncoding: ( NSStringEncoding ) encoding
{
    NSData * data = nil;
    int encodingInt = ( ( int ) encoding );
    NSStringEncoding activeEncoding = ( encodingInt < 0 ) ? [ Localizator encodingForActiveLanguage ] : encoding;
    
    activeEncoding = NSUTF8StringEncoding;
    
    data = [ string dataUsingEncoding: activeEncoding
                 allowLossyConversion: NO
            ];
    
    return data;
}


//==============================================================================
+ ( NSString * ) charsetForActiveLanguage
{
    NSString * activeCharset = @"utf-8";
    return activeCharset;
    
    NSArray * langs = [ NSLocale preferredLanguages ];
    
    //    //NSLog( @"preferred locales = %@", langs );
    
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    
    if( lang )
    {
        if( [ lang isEqualToString: @"en" ] )               // English      (!)
        {
            activeCharset = @"utf-8";
        }
        else if( [ lang isEqualToString: @"de" ] )          // German       (!)
        {
            activeCharset = @"windows-1252";
        }
        else if( [ lang isEqualToString: @"es" ] )          // Spanish      (!)
        {
            activeCharset = @"windows-1252";
        }
        else if( [ lang isEqualToString: @"fr" ] )          // French       (!)
        {
            activeCharset = @"windows-1252";
        }
        else if( [ lang isEqualToString: @"it" ] )          // Italian      (!)
        {
            activeCharset = @"windows-1252";
        }
        else if( [ lang isEqualToString: @"ja" ] )          // Japanese
        {
            activeCharset = @"utf-8";
        }
        else if( [ lang isEqualToString: @"ko" ] )          // Korean
        {
            activeCharset = @"utf-8";
        }
        else if( [ lang isEqualToString: @"nl" ] )          // Dutch        (!)
        {
            activeCharset = @"utf-8";
        }
        else if( [ lang isEqualToString: @"pt" ] )          // Portuguese   (!)
        {
            activeCharset = @"windows-1252";
        }
        else if( [ lang isEqualToString: @"ru" ] )          // Russian
        {
            activeCharset = @"windows-1251";
        }
        else if( [ lang isEqualToString: @"uk" ] )          // Ukrainian
        {
            activeCharset = @"windows-1251";
        }
        else if( [ lang isEqualToString: @"zh-Hans" ] )     // Chinese
        {
            activeCharset = @"utf-8";
        }
    }
    
    //    activeCharset = @"utf-8";
    
    return activeCharset;
}


//==============================================================================
+ ( NSString * ) localeIdentifierForActiveLanguage
{
    NSString * activeIdentifier = @"en_EN";
    NSArray * langs = [ NSLocale preferredLanguages ];
    
    //    //NSLog( @"preferred locales = %@", langs );
    
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    
    if( lang )
    {
        if( [ lang isEqualToString: @"en" ] )               // English      (!)
        {
            activeIdentifier = @"en_EN";
        }
        else if( [ lang isEqualToString: @"de" ] )          // German       (!)
        {
            activeIdentifier = @"de_DE";
        }
        else if( [ lang isEqualToString: @"es" ] )          // Spanish      (!)
        {
            activeIdentifier = @"es_ES";
        }
        else if( [ lang isEqualToString: @"fr" ] )          // French       (!)
        {
            activeIdentifier = @"fr_FR";
        }
        else if( [ lang isEqualToString: @"it" ] )          // Italian      (!)
        {
            activeIdentifier = @"it_IT";
        }
        else if( [ lang isEqualToString: @"ja" ] )          // Japanese
        {
            activeIdentifier = @"ja_JP";
        }
        else if( [ lang isEqualToString: @"ko" ] )          // Korean
        {
            activeIdentifier = @"ko_KR";
        }
        else if( [ lang isEqualToString: @"nl" ] )          // Dutch        (!)
        {
            activeIdentifier = @"nl_NL";
        }
        else if( [ lang isEqualToString: @"pt" ]||[ lang isEqualToString: @"pt-PT" ] )          // Portuguese   (!)
        {
            activeIdentifier = @"pt_PT";
        }
        else if( [ lang isEqualToString: @"ru" ] )          // Russian
        {
            activeIdentifier = @"ru_RU";
        }
        else if( [ lang isEqualToString: @"uk" ] )          // Ukrainian
        {
            activeIdentifier = @"uk_UA";
        }
        else if( [ lang isEqualToString: @"zh-Hans" ] )     // Chinese simple
        {
            activeIdentifier = @"zh_Hans";
        }
        else if( [ lang isEqualToString: @"zh-Hant" ] )     // Chinese tradit.
        {
            activeIdentifier = @"zh_Hant";
        }
        else if( [ lang isEqualToString: @"sv" ] )          // Swedish
        {
            activeIdentifier = @"sv_SV";
        }
        else if( [ lang isEqualToString: @"pl" ] )          // Polish
        {
            activeIdentifier = @"pl_PL";
        }
        else if( [ lang isEqualToString: @"tr" ] )          // Turkish
        {
            activeIdentifier = @"tr_TK";
        }
        else if( [ lang isEqualToString: @"da" ] )          // Danish
        {
            activeIdentifier = @"da_DN";
        }
        else if( [ lang isEqualToString: @"nb" ] )          // Norwegian
        {
            activeIdentifier = @"nb_NO";
        }
        else if( [ lang isEqualToString: @"nn" ] )          // Norwegian2
        {
            activeIdentifier = @"nn_NO";
        }
        else if( [ lang isEqualToString: @"ca" ] )          // Catalan
        {
            activeIdentifier = @"ca_ES";
        }
        else if( [ lang isEqualToString: @"cs" ] )          // Czech
        {
            activeIdentifier = @"cs_CZ";
        }
        else if( [ lang isEqualToString: @"el" ] )          // Greek
        {
            activeIdentifier = @"el_EL";
        }
        else if( [ lang isEqualToString: @"fi" ] )          // Finiish
        {
            activeIdentifier = @"fi_FI";
        }
        
        
    }
    
    return activeIdentifier;
}

+(NSString*)dateFormatForActiveLanguage
{
    NSString * activeIdentifier;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *cLocale = [[NSLocale alloc] initWithLocaleIdentifier:[Localizator localeIdentifierForActiveLanguage]];
    if([[[NSLocale currentLocale] identifier] isEqualToString:@"en_GB"])
    {
        [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setDateFormat:@"dd-MM-yy"];
    }
    else
    {
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    activeIdentifier = [dateFormatter stringFromDate:[NSDate date]];
    
    activeIdentifier = [activeIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    activeIdentifier = [activeIdentifier stringByReplacingOccurrencesOfString:@"/" withString:@"."];

    return activeIdentifier;
}

@end
