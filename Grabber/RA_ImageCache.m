//
//  RA_ImageCache.m
//  RestaurantApp
//
//  Created by World on 12/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ImageCache.h"

#define TMP NSTemporaryDirectory()

@implementation RA_ImageCache
{
    
}

- (void) cacheImage: (NSString *) ImageURLString
{
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
    //generating unique name for the cached file with ImageURLString so you can retrive it back
    NSMutableString *tmpStr = [NSMutableString stringWithString:ImageURLString];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    
    NSString *filename = [NSString stringWithFormat:@"%@",tmpStr];
    
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
        UIImage *image = [[UIImage alloc] initWithData: data];
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
    }
}

- (UIImage *) getImage: (NSString *) ImageURLString
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:ImageURLString];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    
    NSString *filename = [NSString stringWithFormat:@"%@",tmpStr];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:uniquePath];
        image = [[UIImage alloc] initWithData:data] ; // this is the cached image
    }
    else
    {
        // get a new one
        [self cacheImage: ImageURLString];
        NSData *data = [[NSData alloc] initWithContentsOfFile:uniquePath];//[[NSData alloc] initWithContentsOfURL:uniquePath];
        image = [[UIImage alloc] initWithData:data];
        
    }
    return image;
}

@end
