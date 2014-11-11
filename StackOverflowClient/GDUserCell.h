//
//  UserCell.h
//  StackOverflowClient
//
//  Created by Alex G on 10.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;

@end
