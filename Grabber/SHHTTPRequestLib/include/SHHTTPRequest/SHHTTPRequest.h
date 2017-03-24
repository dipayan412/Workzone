//
//  SHHTTPRequest.h
//  SHHTTPRequest
//
//  Created by shabib hossain on 1/24/14.
//  Copyright (c) 2014 shabib hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHTTPRequest;

@protocol SHHTTPRequestDelegate <NSObject>

- (void)request:(SHHTTPRequest *)fetcher didFinishLoadingData:(NSData *)data;
- (void)request:(SHHTTPRequest *)fetcher didFailedWithError:(NSError *)error;

@end

@interface SHHTTPRequest : NSObject
{
    NSMutableData *data;
    NSURLConnection *connection;
    NSMutableURLRequest *request;
    NSURLRequestCachePolicy cachePolicy;
}

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSDictionary *parameters;
@property (nonatomic, readwrite) NSInteger tag;
@property (nonatomic, readwrite) NSTimeInterval timeout;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, weak) id <SHHTTPRequestDelegate> delegate;

// initialise the request obejct
/*
 * parameters:
 * url: url of the api
 * data: data to post
 * delegate: callback delegate
 */
- (id)initWithURL:(NSString *)url data:(NSDictionary *)parameters delegate:(id)delegate;

// start the get request
- (void)initGetRequest;

// start the post request
- (void)initPostRequest;

// start the delete request
- (void)initDeleteRequest;

// start the put (update) request
- (void)initPutRequest;

// start the asynchronous request
- (void)initAsyncGetRequest;

// stop the request
- (void)stopRequest;

// cache data
- (void)disableCaching:(BOOL)yes;

// the requsted url
- (NSString *)getURL;

@end

@interface NSString (Additions)

- (NSString *)getURLEncodedStringWithCharacters:(NSString *)characters;

@end

@interface NSDictionary (Additions)

- (NSString *)returnJSONDictionary;

@end

@interface NSData (Additions)

- (NSMutableDictionary *)getDeserializedDictionary;
- (NSArray *)getDeserializedArray;

@end
