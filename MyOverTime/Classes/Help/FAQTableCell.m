//
//  FAQTableCell.m
//  MyOvertime
//
//  Created by Ashif on 6/18/13.
//
//

#import "FAQTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FAQTableCell

@synthesize answerTextView;
@synthesize ansView;
@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndex:(int)_index
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        indexPath = _index;
        NSLog(@"index %d", indexPath);
        answerTextView = [[UIWebView alloc] init];
        
        answerTextView.layer.cornerRadius = 7.0f;
        answerTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        answerTextView.layer.borderWidth = 1.0f;
        answerTextView.backgroundColor = [UIColor clearColor];
        answerTextView.opaque = NO;
        answerTextView.scalesPageToFit = YES;
        
        ansView = [[UITextView alloc] init];
        
        ansView.layer.cornerRadius = 7.0f;
        ansView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        ansView.layer.borderWidth = 1.0f;
        ansView.backgroundColor = [UIColor clearColor];
        ansView.editable = NO;
        ansView.font = [UIFont fontWithName:@"Helvetica" size:13];
        [self.contentView addSubview:ansView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    if(indexPath == 4 ||indexPath ==  6 || indexPath == 9 || indexPath == 10 || indexPath == 11 || indexPath == 12)
    {
        ansView.frame = CGRectMake(8 ,0 , 302, 100);
    }
    else
    {
        ansView.frame = CGRectMake(8 ,0 , 302, 200);
    }
    */
    ansView.frame = CGRectMake(8 ,0 , 302, 200);
}

-(void)setAnswerText:(NSString*)_answer
{
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:_answer ofType:@"htm"];
    
    [answerTextView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_answer ofType:@"htm"] isDirectory:NO]]];
    
    return;
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
    // rykosoft: added custom encoding for german
    NSStringEncoding encoding = NSUTF8StringEncoding;
    
    NSArray * langs = [ NSLocale preferredLanguages ];
    NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
    if( [ lang isEqualToString: @"de" ] )
        encoding = NSWindowsCP1252StringEncoding;
    
    NSString *htmlString = [[NSString alloc] initWithData: [readHandle readDataToEndOfFile]
                                                 encoding: encoding
                            ];
    
    // htmlString = [htmlString stringByReplacingOccurrencesOfString:@"†" withString:@"Ü"];
    //	helpContentView.delegate = self;
    answerTextView.opaque = NO;
    answerTextView.backgroundColor = [UIColor clearColor];
//    [answerTextView loadHTMLString:[htmlString stringByReplacingOccurrencesOfString:@"†" withString:@"Ü"] baseURL:nil];
    [htmlString release];
    */
    ansView.text = _answer;
}

@end
