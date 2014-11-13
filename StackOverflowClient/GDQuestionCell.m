//
//  QuestionCell.m
//  StackOverflowClient
//
//  Created by Alex G on 13.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDQuestionCell.h"
#import "UIColor+GD.h"

@interface GDQuestionCell () {
    __weak IBOutlet UIView *backgroundViewAnswered;
}

@property (weak, nonatomic) IBOutlet UILabel *answeredLabel;

@end

@implementation GDQuestionCell

@synthesize answered = _answered;

- (void)setAnswered:(BOOL)answered {
    _answered = answered;
    _answeredLabel.text = answered ? @"Answered" : @"Not answered";
    backgroundViewAnswered.backgroundColor = answered ? [UIColor colorWithRGB:0x78A55D] : [UIColor colorWithRGB:0xB97568];
}

- (void)awakeFromNib {
    // Initialization code
    backgroundViewAnswered.layer.cornerRadius = 2;
    backgroundViewAnswered.layer.borderWidth = 1;
    backgroundViewAnswered.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.1] CGColor];
    _avatarImageView.layer.cornerRadius = 4;
    _avatarImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    backgroundViewAnswered.hidden = (_answeredLabel.text == nil) || ([_answeredLabel.text isEqualToString:@""]);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _avatarImageView.image = nil;
}

@end
