//
//  ALTabBarView.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarView.h"

@implementation ALTabBarView

@synthesize delegate;
@synthesize homeButton;

- (void)dealloc {
    [homeButton release];
    delegate = nil;
    [super dealloc];
}

-(id) init{
    if((self = [super init]))
    {
        
        
    }
    return self ;

}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
    {
        // Initialization code
    }
    return self;
}

-(void) selectTab:(NSInteger)index
{
    for (UIButton * button in [self subviews]) {
        if([button isKindOfClass:[UIButton class]])
            button.selected = NO;
    }
    
    for(int i=0; i<[self subviews].count; i++)
    {
        id view = [self.subviews objectAtIndex:i]; 
        if([view isKindOfClass:[UIButton class]])
        {
            if(index == [(UIButton *) view tag])
            {
                [(UIButton*)view setSelected:YES];
                if([delegate respondsToSelector:@selector(tabWasSelected:)])
                    [delegate tabWasSelected:index];
                break;
            }
        }
    }
}
//Let the delegate know that a tab has been touched
-(IBAction) touchButton:(id)sender 
{
    for (UIButton * button in [self subviews]) {
        if([button isKindOfClass:[UIButton class]])
            button.selected = NO;
    }
    [(UIButton*)sender setSelected:YES];
    
    if([delegate respondsToSelector:@selector(tabWasSelected:)])
        [delegate tabWasSelected:[(UIButton *)sender tag]];
}
/*
-(void) update
{
    
            NSString * homeImage  = @"BBB_Home_";
            NSString * light = @"_Light.png";
            NSString * normal = @"_Normal.png";
    NSString * contry = [[[SharedData getSharedInstance] userProfile] countryName] ;
        if(contry==nil || [contry isKindOfClass:[NSNull class]])
        {
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:NATIONAL_ISLAND] stringByAppendingString:normal]] forState:UIControlStateNormal];
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:NATIONAL_ISLAND] stringByAppendingString:light]] forState:UIControlStateHighlighted];
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:NATIONAL_ISLAND] stringByAppendingString:light]] forState:UIControlStateSelected];
        }
        else
        {
            contry = [[[[SharedData getSharedInstance] userProfile] countryName] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:contry] stringByAppendingString:normal]] forState:UIControlStateNormal];
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:contry] stringByAppendingString:light]] forState:UIControlStateHighlighted];
            [self.homeButton setBackgroundImage:[UIImage imageNamed:[[homeImage stringByAppendingString:contry] stringByAppendingString:light]] forState:UIControlStateSelected];
        }
    
    
}
 */
@end
