//
//  ShopCreateLocationCell.m
//  iOS Prototype
//
//  Created by World on 3/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ShopCreateLocationCell.h"

@implementation ShopCreateLocationCell

@synthesize locationCellName;
@synthesize locationMapView;
@synthesize delegate;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
    if (self)
    {
        locationCellName = [[UILabel alloc] init];
        locationCellName.backgroundColor = [UIColor clearColor];
        locationCellName.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:locationCellName];
        
        locationMapView = [[BMMapView alloc] initWithFrame:CGRectMake(15, 40, 100, 20)];
//        [locationMapView setShowsUserLocation:YES];
        [self.contentView addSubview:locationMapView];
        
        locateButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        locateButton.tintColor = [UIColor redColor];
        [locateButton addTarget:self action:@selector(locateButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:locateButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    locationCellName.frame = CGRectMake(15, 10, 100, 30);
    locationMapView.frame = CGRectMake(15, 40, self.contentView.frame.size.width - 30, self.contentView.frame.size.height - 50);
    locateButton.frame = CGRectMake(280, 45, 20, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)locateButtonAction
{
    if(delegate)
    {
        [delegate locateButtonTapped];
    }
}
@end
