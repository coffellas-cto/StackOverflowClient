//
//  GDSplitViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDSplitViewController.h"
#import "GDUsersViewController.h"
#import "GDQuestionsViewController.h"

@interface GDSplitViewController () <UISplitViewControllerDelegate> {
    GDUsersViewController *usersVC;
    GDQuestionsViewController *questionsVC;
    BOOL collapsedSecondaryVC;
}

@end

@implementation GDSplitViewController

#pragma mark - Public Methods
- (void)showUsersVC {
    [self createUsersVC];
    [self showDetailViewController:usersVC sender:self];
}

- (void)showQuestionsVC {
    if (!questionsVC) {
        questionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QUESTIONS_VC"];
    }
    
    [self showDetailViewController:questionsVC sender:self];
}

#pragma mark - Private Methods
- (void)createUsersVC {
    if (!usersVC) {
        usersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"USERS_VC"];
    }
}

#pragma mark - UISplitViewControllerDelegate Methods
- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    // TODO: This Method is called only once. Get into it.
    if (!collapsedSecondaryVC) {
        collapsedSecondaryVC = YES;
        return YES;
    }
    
    return NO;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self createUsersVC];
    self.viewControllers = [NSArray arrayWithObjects:[self.viewControllers firstObject], usersVC, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
