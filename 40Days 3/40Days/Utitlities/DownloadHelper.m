//
//  DownloadHelper.m
//  40Days
//
//  Created by Ashif on 6/13/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "DownloadHelper.h"

@implementation DownloadHelper

@synthesize directoryPath;

static DownloadHelper *instance;

+(DownloadHelper*)getInstance
{
    if (instance == nil)
    {
        instance = [[DownloadHelper alloc] init];
    }
    
    return instance;
}

-(void)prepareValues
{
    fileTag = [AppData getDownloadedFileTag];
    
    if(fileTag == 0)
    {
        fileTag = 1;
    }
    else
    {
        fileTag += 1;
    }
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"/40Days"];
    self.directoryPath = dataPath;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        NSError* error;
        if( [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
}

-(void)startFileDownload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if(fileTag > 40)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return;
    }
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:kAudioFileUrlStarting];
    
    [url appendFormat:@"%d%@", fileTag, kfileType];
    
    NSURL *requestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"request %@", requestURL);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Day_%d.mp3", self.directoryPath, fileTag];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    
    [request setDownloadDestinationPath:filePath];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark-ASIHTTP delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [AppData setDownloadedFileTag:fileTag];
    
    fileTag += 1;
    [self startFileDownload];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{   
    //    NSError *error = [request error];
    
}

@end
