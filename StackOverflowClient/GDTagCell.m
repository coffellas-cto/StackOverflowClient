//
//  GDTagCell.m
//  StackOverflowClient
//
//  Created by Alex G on 13.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDTagCell.h"

@interface GDTagCell ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation GDTagCell

@synthesize backgroundView = _backgroundView;

- (CGSize)intrinsicContentSize
{
    CGSize size = [_titleLabel intrinsicContentSize];
    size.width += 6;
    size.height += 4;
    
    return size;
}


- (void)awakeFromNib {
    // Initialization code
    _backgroundView.layer.cornerRadius = 2;
    _backgroundView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.1] CGColor];
    _backgroundView.layer.borderWidth = 1;
}

@end
