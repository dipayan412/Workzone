//
//  DownloadHelper.h
//  40Days
//
//  Created by Ashif on 6/13/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "AppData.h"

@interface DownloadHelper : NSObject <ASIHTTPRequestDelegate>
{
    int fileTag;
}

@property (nonatomic, retain) NSString *directoryPath;

+(DownloadHelper*)getInstance;

-(void)prepareValues;
-(void)startFileDownload;

@end
