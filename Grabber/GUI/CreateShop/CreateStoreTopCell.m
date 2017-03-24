//
//  CreateStoreTopCell.m
//  Grabber
//
//  Created by World on 3/23/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "CreateStoreTopCell.h"

@implementation CreateStoreTopCell

@synthesize storeImageView;
@synthesize storeNameField;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CreateStoreTopCell"];
    if (self)
    {
        storeImageView = [[UIImageView alloc] init];
        storeImageView.backgroundColor = [UIColor clearColor];
        storeImageView.image = [UIImage imageNamed:@"ShopCreateDefaultImage.png"];
        [self.contentView addSubview:storeImageView];
        
        storeNameField = [[UITextField alloc] init];
        storeNameField.backgroundColor = [UIColor clearColor];
        storeNameField.placeholder = @"Store name";
        storeNameField.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:storeNameField];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    storeImageView.frame = CGRectMake(10, 10, 100, 100);
    storeNameField.frame = CGRectMake(storeImageView.frame.size.width + 20, 0,self.contentView.frame.size.width - storeImageView.frame.size.width - 20, self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
