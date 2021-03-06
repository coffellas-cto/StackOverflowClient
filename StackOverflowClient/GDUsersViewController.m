//
//  HomeViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 10.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDUsersViewController.h"
#import "GDUserCell.h"
#import "GDUser.h"
#import "GDCacheController.h"
#import "GDNetworkController.h"
#import "GDWebViewController.h"

@interface GDUsersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GDUsersViewController {
    NSMutableArray *usersArray;
    NSURLSessionDataTask *curDataTask;
    BOOL canLoadMoreUsers;
}

#pragma mark - Private Methods

- (void)cancelCurTask {
    if ([curDataTask state] != NSURLSessionTaskStateCompleted) {
        [curDataTask cancel];
    }
}

- (void)searchForUsers {
    [_activityIndicator startAnimating];
    canLoadMoreUsers = NO;
    curDataTask = [GDNetworkController searchForUsersWithQuery:_searchBar.text andOffset:[usersArray count] completionHandler:^(NSArray *usersJSONArray, NSString *errorString, BOOL hasMore) {
        [_activityIndicator stopAnimating];
        canLoadMoreUsers = hasMore;
        if (errorString) {
            NSLog(@"%@", errorString);
            return;
        }
        
        NSArray *newUsersArray = [GDUser usersWithJSONArray:usersJSONArray];
        [usersArray addObjectsFromArray:newUsersArray];
        [_tableView reloadData];
    }];
}

#pragma mark - UITableView Delegates Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USER_CELL" forIndexPath:indexPath];
    GDUser *curUser = usersArray[indexPath.row];
    cell.userNameLabel.text = curUser.name;
    cell.userTypeLabel.text = curUser.userType;
    cell.userSiteLabel.text = curUser.websiteURL;
    cell.reputationLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)curUser.reputation];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor whiteColor] : [UIColor colorWithWhite:0.96 alpha:1];
    
    NSString *avatarURL = curUser.profileImageURL;
    
    if (avatarURL) {
        [GDNetworkController loadAvatarWithURL:avatarURL
                                     indexPath:indexPath
                             activityIndicator:cell.activityIndicatorAvatar
                                     imageView:cell.avatarImageView
                                    completion:^(UIImage *image, NSIndexPath *indexPathCompletion)
        {
            GDUserCell *cell = (GDUserCell *)[_tableView cellForRowAtIndexPath:indexPathCompletion];
            [UIView transitionWithView:cell.avatarImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                cell.avatarImageView.image = image;
            } completion:nil];
        }];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [usersArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [usersArray count] - 2) {
        if (!canLoadMoreUsers)
            return;
        
        [self searchForUsers];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDUser *user = usersArray[indexPath.row];
    NSString *URL = user.stackOverflowURL;
    if (URL) {
        GDWebViewController *webVC = [GDWebViewController new];
        webVC.URLString = URL;
        webVC.title = user.name;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchText = searchBar.text;
    if ([searchText isEqualToString:@""] || (searchText == nil)) {
        return;
    }
    
    [self cancelCurTask];
    usersArray = [NSMutableArray array];
    [self searchForUsers];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    usersArray = [NSMutableArray array];
    canLoadMoreUsers = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
