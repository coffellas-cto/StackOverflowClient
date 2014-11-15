//
//  GDProfileViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 15.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDProfileViewController.h"
#import "GDNetworkController.h"
#import "GDUser.h"
#import "GDWebViewController.h"

@interface GDProfileViewController () {
    NSURLSessionDataTask *task;
    NSString *userURL;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *typeBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;
@property (weak, nonatomic) IBOutlet UILabel *regDateLabel;

@end

@implementation GDProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = 100;
    _avatarImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _typeBackgroundView.layer.cornerRadius = 3;
    [_avatarActivityIndicator startAnimating];
    _nameLabel.text = nil;
    _siteLabel.text = nil;
    _typeLabel.text = @"Unknown";
    _reputationLabel.text = nil;
    _regDateLabel.text = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    task = [GDNetworkController getSelfWithCompletion:^(NSDictionary *JSONDic, NSString *errorString) {
        GDUser *user = [GDUser userWithJSONDictionary:JSONDic];
        _nameLabel.text = user.name;
        self.title = user.name;
        _siteLabel.text = user.websiteURL;
        _typeLabel.text = user.userType;
        _reputationLabel.text = [@(user.reputation) stringValue];
        _regDateLabel.text = user.regDate;
        userURL = user.stackOverflowURL;
        
        [GDNetworkController loadAvatarWithURL:user.profileImageURL indexPath:nil activityIndicator:_avatarActivityIndicator imageView:_avatarImageView completion:^(UIImage *image, NSIndexPath *indexPath) {
            [UIView transitionWithView:_avatarImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _avatarImageView.image = image;
            } completion:nil];
        }];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [task cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row != 2) || !userURL)
        return;
    
    GDWebViewController *webVC = [GDWebViewController new];
    webVC.URLString = userURL;
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
