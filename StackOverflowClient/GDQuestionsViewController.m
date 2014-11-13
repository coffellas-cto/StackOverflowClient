//
//  GDQuestionsViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDQuestionsViewController.h"
#import "GDQuestion.h"
#import "GDUser.h"
#import "GDNetworkController.h"
#import "GDQuestionCell.h"

@interface GDQuestionsViewController () {
    NSMutableArray *questionsArray;
    NSURLSessionDataTask *curDataTask;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GDQuestionsViewController

#pragma mark - Private Methods
- (void)cancelCurTask {
    if ([curDataTask state] != NSURLSessionTaskStateCompleted) {
        [curDataTask cancel];
    }
}

#pragma mark - UITableView Delegates Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    
    GDQuestion *q = questionsArray[indexPath.row];
    cell.userNameLabel.text = q.owner.name;
    cell.questionTextLabel.text = q.title;
    cell.answerCountLabel.text = [@(q.answerCount) stringValue];
    cell.viewCountLabel.text = [@(q.viewCount) stringValue];
    cell.answeredLabel.text = q.answered ? @"Answered" : @"Not answered";
    
    NSString *avatarURL = q.owner.profileImageURL;
    
    if (avatarURL) {
        [GDNetworkController loadAvatarWithURL:avatarURL
                                     indexPath:indexPath
                             activityIndicator:cell.activityIndicatorAvatar
                                     imageView:cell.avatarImageView
                                    completion:^(UIImage *image, NSIndexPath *indexPathCompletion)
         {
             GDQuestionCell *cell = (GDQuestionCell *)[_tableView cellForRowAtIndexPath:indexPathCompletion];
             [UIView transitionWithView:cell.avatarImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                 cell.avatarImageView.image = image;
             } completion:nil];
         }];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questionsArray count];
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSLog(@"%@", searchBar.text);
    
    NSString *searchText = searchBar.text;
    if ([searchText isEqualToString:@""] || (searchText == nil)) {
        return;
    }
    
    [self cancelCurTask];
    
    [_activityIndicator startAnimating];
    
    curDataTask = [GDNetworkController searchForQuestionsWithQuery:searchText completionHandler:^(NSArray *questionsJSONArray, NSString *errorString) {
        [_activityIndicator stopAnimating];
        NSArray *newQuestionsArray = [GDQuestion questionsWithJSONArray:questionsJSONArray];
        questionsArray = [NSMutableArray arrayWithArray:newQuestionsArray];
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
    
    _tableView.estimatedRowHeight = 420;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    questionsArray = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
