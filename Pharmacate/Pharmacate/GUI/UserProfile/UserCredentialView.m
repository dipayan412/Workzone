//
//  UserCredentialView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserCredentialView.h"

@implementation UserCredentialView

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
    float imageHeight = 100;
    float imageWidth = 100;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedString(kProfileDetailUserInformation, nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    titleLabel.numberOfLines = 1;
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *separatorLineTitleLabel = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height - 1, self.frame.size.width, 1)];
    separatorLineTitleLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLineTitleLabel];
    
    UIImageView *userImageView = [[UIImageView alloc] initWithImage:[UserDefaultsManager getProfilePicture]];
    userImageView.frame = CGRectMake(self.frame.size.width/2 - imageHeight/2, separatorLineTitleLabel.frame.origin.y + 100, imageHeight, imageWidth);
    userImageView.layer.cornerRadius = imageHeight/2;
    userImageView.clipsToBounds = YES;
    [self addSubview:userImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userImageView.frame.origin.y + userImageView.frame.size.height + 25, self.frame.size.width, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [UserDefaultsManager getUserFullName];
    nameLabel.font = [UIFont systemFontOfSize:19.0f];
    nameLabel.numberOfLines = 1;
    nameLabel.minimumScaleFactor = 0.5f;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + nameLabel.frame.size.height + 25, self.frame.size.width, 20)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = [UserDefaultsManager getUserName];
    emailLabel.font = [UIFont systemFontOfSize:19.0f];
    emailLabel.numberOfLines = 1;
    emailLabel.minimumScaleFactor = 0.5f;
    emailLabel.adjustsFontSizeToFitWidth = YES;
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:emailLabel];
}

@end
