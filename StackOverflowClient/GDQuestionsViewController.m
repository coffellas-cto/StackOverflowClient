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
#import "GDTagsCell.h"
#import "GDWebViewController.h"

@interface GDQuestionsViewController () <UITableViewDataSource, UITableViewDelegate> {
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
    GDQuestion *q = questionsArray[indexPath.section];

    if (indexPath.row == 1) {
        GDTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAGS_CELL" forIndexPath:indexPath];
        cell.tagsArray = q.tags;
        return cell;
    }
    
    GDQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    
    cell.userNameLabel.text = q.owner.name;
    cell.questionTextLabel.text = q.title;
    cell.answerCountLabel.text = [@(q.answerCount) stringValue];
    cell.viewCountLabel.text = [@(q.viewCount) stringValue];
    cell.answered = q.answered;
    
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
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [questionsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *retVal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    retVal.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    return retVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return UITableViewAutomaticDimension;
    
    GDQuestion *q = questionsArray[indexPath.section];
    if ([q.tags count] == 0)
        return 0;

    // Calculate the height based on tags array
    CGFloat retVal = 17.5 + 8 + 4;
    
    NSUInteger breaksCount = 0;
    CGFloat totalWidth = 0;
    for (NSString *tag in q.tags) {
        totalWidth += 8; // Collection view section margin
        totalWidth += 6; // 3 points by 2 for label margins
        CGSize labelSize = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                             options:NSStringDrawingTruncatesLastVisibleLine
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}
                                             context:nil].size;
        totalWidth += labelSize.width;
        if (totalWidth > CGRectGetWidth(self.view.frame) + 8) {
            breaksCount++;
            totalWidth = 0;
        }
    }
    
    retVal += breaksCount * (17.5 + 4);
    return retVal;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDQuestion *q = questionsArray[indexPath.section];
    
    NSString *URL = q.link;
    if (URL) {
        GDWebViewController *webVC = [GDWebViewController new];
        webVC.URLString = URL;
        webVC.title = q.title;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    
    curDataTask = [GDNetworkController searchForQuestionsWithQuery:searchText andOffset:[questionsArray count] completionHandler:^(NSArray *questionsJSONArray, NSString *errorString, BOOL hasMore) {
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
    [_tableView registerNib:[UINib nibWithNibName:@"GDTagsCell" bundle:nil] forCellReuseIdentifier:@"TAGS_CELL"];
    questionsArray = [NSMutableArray array];
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
