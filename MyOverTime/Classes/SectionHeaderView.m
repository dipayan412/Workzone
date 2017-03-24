
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView


@synthesize titleLabel=_titleLabel,  disclosureButton=_disclosureButton, delegate=_delegate, section=_section;


+ (Class)layerClass
{
    return [CAGradientLayer class];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate
{    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];

        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.origin.y += 5;
        titleLabelFrame.size.width =  self.bounds.size.width - 35;
        titleLabelFrame.size.height = 77;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        
        UILabel *tLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        tLabel.text = title;
        tLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        tLabel.textColor = [UIColor blackColor];
        tLabel.numberOfLines = 0;
        tLabel.textAlignment = UITextAlignmentLeft;
        [tLabel sizeToFit];
        tLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tLabel];
        _titleLabel = tLabel;
        
//        MOTLabel *tLabel = [[MOTLabel alloc] initWithFrame:titleLabelFrame];
//        tLabel.text = title;
//        tLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
//        tLabel.textColor = [UIColor blackColor];
//        tLabel.numberOfLines = 3;
//        tLabel.textAlignment = UITextAlignmentLeft;
//        tLabel.verticalAlignment = VerticalAlignmentTop;
////        [tLabel sizeToFit];
//        tLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:tLabel];
//        _titleLabel = tLabel;
        
        if(sectionNumber != 17)
        {
            UIView *underlineview = [[UIView alloc] initWithFrame:CGRectMake(3, self.frame.size.height - 1, self.frame.size.width - 6, 1)];
            underlineview.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:underlineview];
        }
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, -2.0, 35.0, 35.0);
        [button setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"enclose.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;
        
        // Set the colors for the gradient layer.
        /*
        static NSMutableArray *colors = nil;
        if (colors == nil)
        {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
         */
    }
    
    return self;
}

-(void)toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction
{    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction)
    {
        if (self.disclosureButton.selected)
        {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)])
            {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)])
            {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

@end
