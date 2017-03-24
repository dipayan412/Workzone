//
//  PageView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "PageView.h"

@implementation PageView

- (id)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 300)];
    pc.backgroundColor = [UIColor clearColor];
    pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    pc.currentPageIndicatorTintColor = [UIColor redColor];
    pc.numberOfPages = 1;
    [pc addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pharmacateIcon@2x.png"]];
    imgView.frame = CGRectMake(self.frame.size.width / 4, 0, self.frame.size.width / 2, self.frame.size.height);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    [pc addSubview:imgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appIcon180.png"]];
    iconImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 60, 0.5*[UIScreen mainScreen].bounds.size.height/4, 120, 120);
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconImageView];
    
    UIImageView *iconImageTextView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pharmacate text.png"]];
    iconImageTextView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 90, iconImageView.frame.origin.y + iconImageView.frame.size.height + 15, 180, 27);
    iconImageTextView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconImageTextView];
    
    UILabel *buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageTextView.frame.origin.y + iconImageTextView.frame.size.height + 3, [UIScreen mainScreen].bounds.size.width, 20)];
    buttonTitleLabel.backgroundColor = [UIColor whiteColor];
    buttonTitleLabel.text = @"Discover. Discuss. Decide.";
    buttonTitleLabel.textColor = [UIColor lightGrayColor];
    buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
    buttonTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:buttonTitleLabel];
}

-(void)changePage:(UIPageControl*)pc
{
    if(pc.currentPage == 0)
    {
//        pc.backgroundColor = [UIColor blueColor];
    }
    else if(pc.currentPage == 1)
    {
//        pc.backgroundColor = [UIColor brownColor];
    }
    else if(pc.currentPage == 2)
    {
//        pc.backgroundColor = [UIColor cyanColor];
    }
}

@end
