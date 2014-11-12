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

@interface GDUsersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GDUsersViewController {
    NSMutableArray *usersArray;
    NSURLSessionDataTask *curDataTask;
}

#pragma mark - Private Methods
- (void)cancelCurTask {
    if ([curDataTask state] != NSURLSessionTaskStateCompleted) {
        [curDataTask cancel];
    }
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
    
    __block NSString *avatarURL = curUser.profileImageURL;
    if (avatarURL) {
        UIImage *avatarImage = [GDCacheController objectForKey:curUser.profileImageURL];
        if (avatarImage) {
            cell.avatarImageView.image = avatarImage;
        }
        else {
            [cell.activityIndicatorAvatar startAnimating];
            __block NSIndexPath *indexPathBlock = indexPath;
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:avatarURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.activityIndicatorAvatar stopAnimating];
                });
                
                UIImage *newAvatar = [UIImage imageWithData:data];
                if (newAvatar) {
                    [GDCacheController setObject:newAvatar forKey:avatarURL ofLength:[data length]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GDUserCell *cell = (GDUserCell *)[_tableView cellForRowAtIndexPath:indexPathBlock];
                        [UIView transitionWithView:cell.avatarImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            cell.avatarImageView.image = newAvatar;
                        } completion:nil];
                    });
                }
            }] resume];
        }
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [usersArray count];
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchText = searchBar.text;
    if ([searchText isEqualToString:@""] || (searchText == nil)) {
        return;
    }
    
    [self cancelCurTask];
        
    [_activityIndicator startAnimating];
    
    [GDNetworkController searchForUsersWithQuery:searchText completionHandler:^(NSArray *usersJSONArray, NSString *errorString) {
        [_activityIndicator stopAnimating];
        if (errorString) {
            NSLog(@"%@", errorString);
            return;
        }
        
        NSArray *newUsersArray = [GDUser usersWithJSONArray:usersJSONArray];
        usersArray = [NSMutableArray arrayWithArray:newUsersArray];
        [_tableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    usersArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
