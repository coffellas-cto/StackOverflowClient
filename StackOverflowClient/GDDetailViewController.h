//
//  GDDetailViewController.h
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDDetailViewController : UIViewController

- (void)displayContentController:(UIViewController*)contentVC;
- (void)hideContentController:(UIViewController*)contentVC;

@end