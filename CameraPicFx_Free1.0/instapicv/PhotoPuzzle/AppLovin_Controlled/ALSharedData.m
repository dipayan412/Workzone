//
//  ALSharedData.m
//  PZPlayer
//
//  Created by Granjur on 13/07/2013.
//
//
#import "ALSharedData.h"

static ALSharedData * sharedInstance = nil;

#define STATIC_PLIST_NAME    @"AppLovin_CameraPicFX.plist"

@implementation ALSharedData

@synthesize appLovinInfoObj;
@synthesize playHavenInfoObj;

+(id) getSharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[ALSharedData alloc] init];
    }
    return sharedInstance;
}

+(void) releaseSharedInstance
{
    [sharedInstance release];
    sharedInstance = nil;
}
-(id) init
{
    self= [super init];
    if (self) {
        
        [self readAppLovinPlistFromServer];
        [self readPlayHavenPlistFromServer];
    }
    return self;
}


#pragma mark - AppLovin

- (BOOL) readAppLovinPlistFromServer        // Read AppLovin details from server
{
    // AppLovin
    NSDictionary * appLovinDict = [NSDictionary dictionary];
    
    NSString* appLovinUrl = [self loadAppLovinURL];
    
    
    if(appLovinUrl != nil && ![appLovinUrl isEqualToString:@""])
    {
        appLovinDict = [self getAppLovinDictionaryWithUrlStr:appLovinUrl];
        
    }
    
    if( [[appLovinDict allKeys] count] <= 0 )
    {
        
        NSLog(@"AppLovin SERVER plist load Failed\nLoading... static plist");
        
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSDictionary * root = [NSDictionary dictionaryWithContentsOfFile:[[mainBundle bundlePath] stringByAppendingPathComponent:STATIC_PLIST_NAME]];
        appLovinDict = [root objectForKey:@"AppLovin"];
    }
    
    
    NSLog(@"appLovinDict = %@", appLovinDict);
    
	if ( [[appLovinDict allKeys] count] <= 0 )
    {
		
		NSLog(@"AppLovin static plist load Failed");
		
		return NO;
		
	}
    else
    {
        
        [self loadAppLovinClass:appLovinDict];
    }
    return YES;
    
    
}

- (void) loadAppLovinClass:(NSDictionary*)dicitonary
{
    AppLovinClass * temp = [[AppLovinClass alloc] initWithDictionary:dicitonary];
    
    self.appLovinInfoObj = temp;
    
    NSLog(@"TEMP = %@", temp);
    NSLog(@"self.appLovinInfoObj = %@", self.appLovinInfoObj);
    [temp release];
}


- (NSDictionary *) getAppLovinDictionaryWithUrlStr:(NSString*)urlStr
{
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSError *error = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	
	NSURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSLog(@"Data = %@",response);
    
    // Load Root Dictionary
	NSDictionary *root = nil;
	
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL);
	
	if ([(id)plist isKindOfClass:[NSDictionary class]])
    {
        // Get value of root dictionary
		root = [(NSDictionary *)plist autorelease];
	}
    
    else {
		// clean up ref
		if (plist)
        {
			CFRelease(plist);
		}
		root = nil;
	}
	
	return [root objectForKey:@"AppLovin"];
	
}


- (NSString*) loadAppLovinURL       // Get Url of the plsit
{
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* infoDic = [NSDictionary dictionaryWithContentsOfFile:[[mainBundle bundlePath] stringByAppendingPathComponent:@""]];//@"AppLovinUrl.plist"]];
	
	if ( ! infoDic ) {
		
		NSLog(@"AppLovin URL file: FAIL");
		
		return nil;
		
	}
	
	NSLog(@"AppLovin URL = %@", infoDic);
	
	return [infoDic objectForKey:@"URL"];
	
}

///////////

#pragma mark - PlayHaven

- (BOOL) readPlayHavenPlistFromServer        // Read PlayHaven details from server
{
    // PlayHaven
    NSDictionary * playHavenDict = [NSDictionary dictionary];
    
    NSString* playHavenUrl = [self loadPlayHavenURL];
    
    
    if(playHavenUrl != nil && ![playHavenUrl isEqualToString:@""])
    {
        playHavenDict = [self getPlayHavenDictionaryWithUrlStr:playHavenUrl];
        
    }
    
    if( [[playHavenDict allKeys] count] <= 0 )
    {
        
        NSLog(@"PlayHaven SERVER plist load Failed\nLoading... static plist");
        
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSDictionary * root = [NSDictionary dictionaryWithContentsOfFile:[[mainBundle bundlePath] stringByAppendingPathComponent:STATIC_PLIST_NAME]];
        playHavenDict = [root objectForKey:@"PlayHaven"];
    }
    
    
    NSLog(@"playHavenDict = %@", playHavenDict);
    
	if ( [[playHavenDict allKeys] count] <= 0 )
    {
		
		NSLog(@"PlayHaven static plist load Failed");
		
		return NO;
		
	}
    else
    {
        
        [self loadPlayHavenClass:playHavenDict];
    }
    return YES;
    
    
}

- (void) loadPlayHavenClass:(NSDictionary *)dicitonary
{
    PlayHavenClass * temp = [[PlayHavenClass alloc] initWithDictionary:dicitonary];
    
    self.playHavenInfoObj = temp;
    
    NSLog(@"TEMP = %@", temp);
    NSLog(@"self.playHavenInfoObj = %@", self.playHavenInfoObj);
    [temp release];
}


- (NSDictionary *) getPlayHavenDictionaryWithUrlStr:(NSString *)urlStr
{
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSError *error = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	
	NSURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSLog(@"Data = %@",response);
    
    // Load Root Dictionary
	NSDictionary *root = nil;
	
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL);
	
	if ([(id)plist isKindOfClass:[NSDictionary class]])
    {
        // Get value of root dictionary
		root = [(NSDictionary *)plist autorelease];
	}
    
    else {
		// clean up ref
		if (plist)
        {
			CFRelease(plist);
		}
		root = nil;
	}
	
	return [root objectForKey:@"PlayHaven"];
	
}


- (NSString*) loadPlayHavenURL       // Get Url of the plsit
{
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* infoDic = [NSDictionary dictionaryWithContentsOfFile:[[mainBundle bundlePath] stringByAppendingPathComponent:@"PlayHavenUrl.plist"]];
	
	if ( ! infoDic ) {
		
		NSLog(@"PlayHaven URL file: FAIL");
		
		return nil;
		
	}
	
	NSLog(@"PlayHaven URL = %@", infoDic);
	
	return [infoDic objectForKey:@"URL"];
	
}

///////////

@end
