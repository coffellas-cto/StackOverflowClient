//
//  GDDetailViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDDetailViewController.h"
#import "GDUsersViewController.h"

@interface GDDetailViewController ()
@end

@implementation GDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *g = [self.storyboard instantiateViewControllerWithIdentifier:@"USERS_VC"];
    [self displayContentController:g];
}

- (void)displayContentController:(UIViewController*)contentVC
{
    self.title = contentVC.navigationItem.title;
    [self addChildViewController:contentVC];
    contentVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:contentVC.view];
    [contentVC didMoveToParentViewController:self];
}

- (void)hideContentController:(UIViewController*)contentVC
{
    [contentVC willMoveToParentViewController:nil];
    [contentVC.view removeFromSuperview];
    [contentVC removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
