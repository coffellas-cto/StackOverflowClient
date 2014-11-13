//
//  QuestionCell.m
//  StackOverflowClient
//
//  Created by Alex G on 13.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDQuestionCell.h"

@interface GDQuestionCell () {
    __weak IBOutlet UIView *backgroundViewAnswered;
}

@end

@implementation GDQuestionCell

- (void)awakeFromNib {
    // Initialization code
    backgroundViewAnswered.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
