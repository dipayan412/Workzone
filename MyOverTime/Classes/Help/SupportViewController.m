//
//  SupportViewController.m
//  MyOvertime
//
//  Created by Ashif on 6/19/13.
//
//

#import "SupportViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SupportViewController ()

@end

@implementation SupportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [contentView loadRequest:[self makeUrl:@"support"]];
    [contentView loadHTMLString:[self makeHTMLString:@"support"] baseURL:nil];
    contentView.delegate = self;
    contentView.opaque = NO;
    contentView.backgroundColor = [UIColor  colorWithWhite:1.0f alpha:0.5f];
    
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 1.0f;
    contentView.layer.cornerRadius = 7.0f;
    contentView.scalesPageToFit = NO;
    
    self.title = NSLocalizedString(@"TITLE_SUPPORT", nil);
}

- (NSURLRequest *)makeUrl:(NSString*)key
{
    NSString *l = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle ] pathForResource:l ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[bundle pathForResource:key ofType:@"htm"] isDirectory:NO]];
}

- (NSString *)makeHTMLString:(NSString*)key
{
    NSString *l = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle ] pathForResource:l ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    NSString *filepath = [bundle pathForResource:key ofType:@"htm"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filepath];
    
    NSStringEncoding encoding = NSUTF8StringEncoding;
//    NSStringEncoding encoding = NSWindowsCP1252StringEncoding;
    
    NSArray * langs = [ NSLocale preferredLanguages ];
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    
    if([lang isEqualToString: @"de"])
    {
        encoding = NSWindowsCP1252StringEncoding;
    }
    
//    NSString *htmlString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filepath] encoding:encoding];
    
    NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile]
                                                 encoding: encoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"†" withString:@"Ü"];

    return htmlString;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
    
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
    else
    {
		return YES;
	}
}


@end
