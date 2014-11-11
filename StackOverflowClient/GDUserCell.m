//
//  UserCell.m
//  StackOverflowClient
//
//  Created by Alex G on 10.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDUserCell.h"

@interface GDUserCell ()
@property (weak, nonatomic) IBOutlet UIView *userTypeBackgroundView;

@end

@implementation GDUserCell

- (void)awakeFromNib {
    // Initialization code
    _userTypeBackgroundView.layer.cornerRadius = 2;
    _avatarImageView.layer.cornerRadius = 4;
    _avatarImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userTypeBackgroundView.hidden = (_userTypeLabel.text == nil) || ([_userTypeLabel.text isEqualToString:@""]);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _avatarImageView.image = nil;
}

@end
