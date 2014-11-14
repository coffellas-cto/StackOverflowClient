//
//  WebViewController.h
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GDWebViewModeDefault,
    GDWebViewModeAuthorize
} GDWebViewMode;

@interface WebViewController : UIViewController

@property (nonatomic) GDWebViewMode mode;
@property (nonatomic) NSString *URLString;

@end
